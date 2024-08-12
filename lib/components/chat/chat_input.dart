import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/models/chat.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';

class ChatInput extends ConsumerWidget {
  final Chat chat;

  const ChatInput({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;
    final inputController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.add_rounded, size: 22),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: TextField(
                  controller: inputController,
                  maxLines: 4,
                  minLines: 1,
                  cursorHeight: 18,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter message",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            IconButton.filled(
              icon: const Icon(Icons.arrow_upward_rounded, size: 22),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700),
              onPressed: () async {
                final message = inputController.text;
                if (message.isEmpty) return;
                inputController.clear();
                await ref.read(ChatProvider.provider).sendMessage(
                      chatId: chat.id,
                      message: message,
                      currentAccount: currentAccount,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
