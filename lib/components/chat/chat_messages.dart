import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/components/chat/chat_bubble.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/models/chat_message.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';

class ChatMessages extends ConsumerStatefulWidget {
  final Chat chat;

  const ChatMessages({
    super.key,
    required this.chat,
  });

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  @override
  void initState() {
    super.initState();
    ref
        .read(ChatProvider.provider)
        .updateChatStatusLastSeen(chatId: widget.chat.id)
        .then((value) =>
            ref.invalidate(ChatProvider.getChatStatusProvider(widget.chat.id)));
  }

  @override
  Widget build(BuildContext context) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final messages = ref
            .watch(ChatProvider.getChatMessagesProvider(widget.chat.id))
            .valueOrNull ??
        [];
    final chatProvider = ref.watch(ChatProvider.provider);

    ref.listen(
      ChatProvider.getChatMessagesProvider(widget.chat.id),
      (previous, next) {
        ref
            .read(ChatProvider.provider)
            .updateChatStatusLastSeen(chatId: widget.chat.id);
      },
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final ChatMessage message = messages.elementAt(index);
          final ChatMessage? aboveMessage = messages.elementAtOrNull(index + 1);
          final ChatMessage? belowMessage =
              index > 0 ? messages.elementAtOrNull(index - 1) : null;
          final bool isGroupHead = aboveMessage == null
              ? true
              : aboveMessage.senderId != message.senderId;
          final bool isGroupTail = belowMessage == null
              ? true
              : belowMessage.senderId != message.senderId;

          final bool isMessageUntranslated = chatProvider
                  .translateMessageLocal(
                    message: message,
                    chat: widget.chat,
                    currentAccount: currentAccount,
                  )
                  .text ==
              null;
          final bool isAboveMessageUntranslated = aboveMessage == null
              ? false
              : chatProvider
                      .translateMessageLocal(
                        message: aboveMessage,
                        chat: widget.chat,
                        currentAccount: currentAccount,
                      )
                      .text ==
                  null;

          if (isMessageUntranslated && isAboveMessageUntranslated) {
            return const SizedBox.shrink();
          }

          return ChatBubble(
            chat: widget.chat,
            message: message,
            isFromCurrentAccount: message.senderId == currentAccount.id,
            isGroupHead: isGroupHead,
            isGroupTail: isGroupTail,
          );
        },
      ),
    );
  }
}
