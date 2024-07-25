import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatMessagePage extends StatelessWidget {
  final String id;
  final String messageId;

  const ChatMessagePage({
    super.key,
    required this.id,
    required this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat $id Message $messageId"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Chat message"),
            MaterialButton(
              child: const Text("Go back"),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
