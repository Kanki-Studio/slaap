import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/components/avatar.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/models/chat_message.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';
import 'package:slaap/router.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatItem extends ConsumerWidget {
  final Chat chat;

  const ChatItem({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final accountId = chat.accounts.keys.reduce(
      (value, element) => element != currentAccount.id ? element : value,
    );
    final account =
        ref.watch(AccountProvider.getAccountProvider(accountId)).valueOrNull;
    final status =
        ref.watch(ChatProvider.getChatStatusProvider(chat.id)).valueOrNull;
    final lastMessage = status?.lastMessage;
    final unreadCount = status?.unreadCount;

    if (account == null) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.push(routes.chat(chat.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // avatar
            Avatar(size: 52, photoURL: account.photoURL),

            const SizedBox(width: 12),

            // title and preview
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // name
                      Text(
                        account.id == currentAccount.id
                            ? "${account.name} (You)"
                            : account.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 12),
                      // last timestamp
                      if (lastMessage != null)
                        Text(
                          timeago.format(lastMessage.timestamp.toDate()),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // last message
                      if (lastMessage != null)
                        lastMessageText(context, ref, lastMessage)
                      else
                        const Text(""),
                      const SizedBox(width: 12),
                      // unread count
                      if (unreadCount != null && unreadCount > 0)
                        UnreadCountBadge(count: unreadCount)
                    ],
                  ),
                  // bottom border
                  const SizedBox(height: 8),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lastMessageText(
    BuildContext context,
    WidgetRef ref,
    ChatMessage message,
  ) {
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
      AsyncData(:final value) => Text(
          value.done ? value.text : "translating...",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      _ => const Text(""),
    };
  }
}

class UnreadCountBadge extends StatelessWidget {
  final int count;

  const UnreadCountBadge({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 2,
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
