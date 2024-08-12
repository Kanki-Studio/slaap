import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/components/chat/chat_item.dart';
import 'package:slaap/providers/chat.dart';
import 'package:slaap/router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(ChatProvider.getChatsProvider);

    return Scaffold(
        appBar: AppBar(title: const Text("Chats")),
        body: switch (chats) {
          AsyncData(:final value) => value.isEmpty
              ? SizedBox(
                  height: 320,
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () {
                        context.go(routes.start());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Start new chat",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final chat = value.elementAt(index);
                    return ChatItem(chat: chat);
                  },
                ),
          _ => const SizedBox.shrink(),
        });
  }
}
