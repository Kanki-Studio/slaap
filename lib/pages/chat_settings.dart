import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatSettingsPage extends StatelessWidget {
  final String id;

  const ChatSettingsPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat $id Settings"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Chat settings"),
              MaterialButton(
                child: const Text("Go back"),
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
