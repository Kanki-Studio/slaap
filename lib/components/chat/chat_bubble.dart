import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/components/chat/chat_message_dialog.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/models/chat_message.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';

class ChatBubble extends ConsumerWidget {
  final Chat chat;
  final ChatMessage message;
  final bool isFromCurrentAccount;
  final bool isGroupHead;
  final bool isGroupTail;
  final bool showOriginal;
  final bool showContextMenu;

  const ChatBubble({
    super.key,
    required this.chat,
    required this.message,
    required this.isFromCurrentAccount,
    required this.isGroupHead,
    required this.isGroupTail,
    this.showOriginal = false,
    this.showContextMenu = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(top: isGroupHead ? 10 : 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: showOriginal
          ? originalMessage(context)
          : translatedMessage(context, ref),
    );
  }

  Widget translatedMessage(BuildContext context, WidgetRef ref) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final localTransation =
        ref.watch(ChatProvider.provider).translateMessageLocal(
              message: message,
              chat: chat,
              currentAccount: currentAccount,
            );
    final translation = ref.watch(ChatProvider.translateMessageAIProvider((
      local: localTransation,
      messageId: message.id,
      chatId: chat.id,
    )));

    return switch (translation) {
      AsyncData(:final value) => isFromCurrentAccount
          ? RightChatBubble(
              text: value.text,
              time: formatTime(message.timestamp.toDate()),
              isGroupHead: isGroupHead,
              isGroupTail: isGroupTail,
              onContextMenu: () =>
                  showContextMenu ? onContextMenu(context) : null,
            )
          : LeftChatBubble(
              text: value.text,
              time: formatTime(message.timestamp.toDate()),
              isGroupHead: isGroupHead,
              isGroupTail: isGroupTail,
              onContextMenu: () =>
                  showContextMenu ? onContextMenu(context) : null,
            ),
      _ => isFromCurrentAccount
          ? const RightChatBubbleLoader()
          : const LeftChatBubbleLoader(),
    };
  }

  Widget originalMessage(BuildContext context) {
    return isFromCurrentAccount
        ? RightChatBubble(
            text: message.text,
            time: formatTime(message.timestamp.toDate()),
            isGroupHead: isGroupHead,
            isGroupTail: isGroupTail,
            onContextMenu: () =>
                showContextMenu ? onContextMenu(context) : null,
          )
        : LeftChatBubble(
            text: message.text,
            time: formatTime(message.timestamp.toDate()),
            isGroupHead: isGroupHead,
            isGroupTail: isGroupTail,
            onContextMenu: () =>
                showContextMenu ? onContextMenu(context) : null,
          );
  }

  void onContextMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: const BoxConstraints(maxHeight: 450),
        builder: (context) {
          return ChatMessageDialog(
            chat: chat,
            message: message,
          );
        });
  }

  String formatTime(DateTime date) {
    bool isPm = date.hour > 12;
    String hour = isPm ? "${date.hour - 12}" : "${date.hour}";
    String minute = date.minute.toString().padLeft(2, "0");
    return "$hour:$minute ${isPm ? "PM" : "AM"}";
  }
}

class LeftChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isGroupHead;
  final bool isGroupTail;
  final void Function()? onContextMenu;

  const LeftChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isGroupHead,
    required this.isGroupTail,
    this.onContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: onContextMenu,
          onLongPress: onContextMenu,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(20),
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(12),
                topRight: const Radius.circular(12),
                topLeft: const Radius.circular(12),
                bottomLeft: isGroupTail
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (isGroupTail)
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RightChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isGroupHead;
  final bool isGroupTail;
  final void Function()? onContextMenu;

  const RightChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isGroupHead,
    required this.isGroupTail,
    this.onContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onDoubleTap: onContextMenu,
          onLongPress: onContextMenu,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade700,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(12),
                topLeft: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
                bottomRight: isGroupTail
                    ? const Radius.circular(1)
                    : const Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isGroupTail)
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LeftChatBubbleLoader extends StatelessWidget {
  const LeftChatBubbleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            "...",
            style: TextStyle(color: Colors.black.withAlpha(90)),
          ),
        ),
      ],
    );
  }
}

class RightChatBubbleLoader extends StatelessWidget {
  const RightChatBubbleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            "...",
            style: TextStyle(color: Colors.black.withAlpha(90)),
          ),
        ),
      ],
    );
  }
}
