import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slaap/models/account.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/models/chat_message.dart';
import 'package:slaap/models/chat_status.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/gemini.dart';
import 'package:slaap/providers/prefs.dart';
import 'package:slaap/utils/firestore_doc.dart';

typedef ChatTranslationLocal = ({
  String original,
  String? text,
  String from,
  String to
});
typedef ChatTranslation = ({String text, bool done});

class ChatProvider {
  static final provider = Provider((ref) {
    final accountService = ref.watch(AccountProvider.provider);
    final geminiService = ref.watch(GeminiProvider.provider);
    final prefs = ref.watch(PrefsProvider.instanceProvider);
    return ChatService(
      accountService: accountService,
      geminiService: geminiService,
      prefs: prefs,
    );
  });

  static final getChatsProvider = StreamProvider((ref) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    return ref.watch(provider).getChats(currentAccount: currentAccount);
  });

  static final getChatProvider =
      StreamProvider.family<Chat?, String>((ref, chatId) {
    return ref.watch(provider).getChat(chatId: chatId);
  });

  static final getChatMessagesProvider =
      StreamProvider.family<Iterable<ChatMessage>, String>((ref, chatId) {
    return ref.watch(provider).getChatMessages(chatId: chatId);
  });

  static final getChatStatusProvider =
      FutureProvider.family<ChatStatus, String>((ref, chatId) async {
    final chatProvider = ref.watch(provider);
    final messages = await ref.watch(getChatMessagesProvider(chatId).future);

    return chatProvider.syncChatStatus(
      messages: messages,
      chatId: chatId,
    );
  });

  static final values = <dynamic>[];
  static dynamic last;

  static final translateMessageAIProvider = StreamProvider.family<
      ChatTranslation,
      ({
        ChatTranslationLocal local,
        String messageId,
        String chatId,
      })>((ref, params) {
    return ref.watch(provider).translateMessageAI(
          local: params.local,
          messageId: params.messageId,
          chatId: params.chatId,
        );
  });
}

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AccountService accountService;
  final GeminiService geminiService;
  final SharedPreferences? prefs;

  ChatService({
    required this.accountService,
    required this.geminiService,
    required this.prefs,
  });

  Stream<Iterable<Chat>> getChats({
    required Account currentAccount,
  }) {
    return firestore
        .collection("chats")
        .where("accounts.${currentAccount.id}", isEqualTo: true)
        .snapshots()
        .map(fromFirestoreQuery(Chat.fromMap));
  }

  Stream<Chat?> getChat({
    required String chatId,
  }) {
    return firestore
        .collection("chats")
        .doc(chatId)
        .snapshots()
        .map(fromFirestore(Chat.fromMap));
  }

  Stream<Iterable<ChatMessage>> getChatMessages({
    required String chatId,
  }) {
    return firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(fromFirestoreQuery(ChatMessage.fromMap));
  }

  Future<void> sendMessage({
    required String chatId,
    required String message,
    required Account currentAccount,
  }) async {
    final chatMessage = ChatMessage(
      id: "",
      senderId: currentAccount.id,
      text: message,
      lang: currentAccount.lang.send,
      translations: {},
      timestamp: Timestamp.now(),
    );

    await firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(toFirestore(chatMessage.toMap));
  }

  Future<Chat> startDm({
    required String email,
    required Account currentAccount,
  }) async {
    final otherAccount = await accountService.getAccountByEmail(email);

    var chatQuery = firestore
        .collection("chats")
        .where("accounts.${currentAccount.id}", isEqualTo: true);
    // prevent duplicate where filter where starting dm with self
    if (otherAccount.id != currentAccount.id) {
      chatQuery =
          chatQuery.where("accounts.${otherAccount.id}", isEqualTo: true);
    }
    final chat = await chatQuery
        .limit(1)
        .get()
        .then(fromFirestoreQuery(Chat.fromMap))
        .then((value) => value.firstOrNull);
    if (chat != null) return chat;

    final newChat = Chat(
      id: "",
      accounts: {
        currentAccount.id: true,
        otherAccount.id: true,
      },
      accountLangs: {
        currentAccount.id: currentAccount.lang,
        otherAccount.id: otherAccount.lang,
      },
    );
    await firestore.collection("chats").add(toFirestore(newChat.toMap));
    return newChat;
  }

  ChatTranslationLocal translateMessageLocal({
    required ChatMessage message,
    required Chat chat,
    required Account currentAccount,
  }) {
    final receiveLang = chat.accountLangs[currentAccount.id]?.receive ??
        currentAccount.lang.receive;
    final text = message.lang == receiveLang
        ? message.text
        : message.translations[receiveLang];
    return (
      original: message.text,
      text: text,
      from: message.lang,
      to: receiveLang
    );
  }

  Stream<ChatTranslation> translateMessageAI({
    required ChatTranslationLocal local,
    required String messageId,
    required String chatId,
  }) async* {
    if (local.text != null) {
      yield (text: local.text!, done: true);
      return;
    }

    // stream translation from gemini
    final stream = geminiService.translateMessage(
      message: local.original,
      from: local.from,
      to: local.to,
    );
    String res = "";

    await for (final chunk in stream) {
      yield (text: res += chunk, done: false);
    }
    yield (text: res, done: true);

    // save translation
    await saveTranslation(
      lang: local.to,
      text: res,
      messageId: messageId,
      chatId: chatId,
    );
  }

  Future<void> saveTranslation({
    required String lang,
    required String text,
    required String messageId,
    required String chatId,
  }) async {
    await firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .update({"translations.$lang": text});
  }

  Future<void> dropTranslation({
    required String lang,
    required String messageId,
    required String chatId,
  }) async {
    await firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .update({"translations.$lang": FieldValue.delete()});
  }

  Future<void> updateLanguage({
    required Lang lang,
    required String chatId,
    required Account currentAccount,
  }) async {
    await firestore.collection("chats").doc(chatId).update({
      "accountLangs.${currentAccount.id}": lang.toMap(),
    });
  }

  Future<ChatStatus> syncChatStatus({
    required Iterable<ChatMessage> messages,
    required String chatId,
  }) async {
    final status = _getChatStatus(chatId: chatId);
    final lastSeen = status?.lastSeen;
    int unreadCount = 0;

    for (final message in messages) {
      if (lastSeen != null && lastSeen.compareTo(message.timestamp) >= 1) {
        break;
      }
      unreadCount++;
    }
    final newStatus = ChatStatus(
      lastMessage: messages.firstOrNull,
      lastSeen: lastSeen,
      unreadCount: unreadCount,
    );
    // save updated status in background
    await prefs?.setString("chats:$chatId", newStatus.toJson());
    return newStatus;
  }

  Future<void> updateChatStatusLastSeen({
    required String chatId,
  }) async {
    final status = _getChatStatus(chatId: chatId);
    if (status == null) return;
    final newStatus = status.copyWith(lastSeen: Timestamp.now());
    await prefs?.setString("chats:$chatId", newStatus.toJson());
  }

  ChatStatus? _getChatStatus({
    required String chatId,
  }) {
    final raw = prefs?.getString("chats:$chatId");
    return raw != null ? ChatStatus.fromJson(raw) : null;
  }
}
