import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/components/chat/chat_header.dart';
import 'package:slaap/components/chat/chat_input.dart';
import 'package:slaap/components/chat/chat_messages.dart';
import 'package:slaap/components/lang/lang_picker.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';

class ChatPage extends ConsumerWidget {
  final String id;

  const ChatPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(ChatProvider.getChatProvider(id));

    return switch (chat) {
      AsyncData(:final value) => value != null
          ? readyChatScreen(context, ref, value)
          : waitingChatScreen("Something went wrong"),
      AsyncError() => waitingChatScreen("Something went wrong"),
      _ => waitingChatScreen("Loading..."),
    };
  }

  Scaffold readyChatScreen(BuildContext context, WidgetRef ref, Chat chat) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;

    return Scaffold(
      appBar: AppBar(
        title: ChatHeader(chat: chat),
        actions: [
          IconButton.outlined(
            icon: const Icon(Icons.flag, size: 22),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return LangPicker(
                    title: "Select chat receive language",
                    selected: chat.accountLangs[currentAccount.id]?.receive,
                    onSelect: (lang) async {
                      try {
                        await ref.watch(ChatProvider.provider).updateLanguage(
                              lang: Lang(
                                send: currentAccount.lang.send,
                                receive: lang.value,
                              ),
                              chatId: chat.id,
                              currentAccount: currentAccount,
                            );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Failed to update language"),
                            action: SnackBarAction(
                              label: "Ok",
                              onPressed: () {},
                            ),
                          ));
                        }
                      }
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ChatMessages(
                chat: chat,
              ),
            ),
            ChatInput(chat: chat)
          ],
        ),
      ),
    );
  }

  Scaffold waitingChatScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const SizedBox(width: 40, height: 40),
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          IconButton.outlined(
            icon: const Icon(Icons.settings, size: 22),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const SafeArea(
        child: SizedBox.shrink(),
      ),
    );
  }
}
