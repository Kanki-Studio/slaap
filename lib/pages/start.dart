import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/router.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Conversation"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                  hintText: "Enter number to start conversation"),
              onSubmitted: (value) {
                final id = textController.text;
                context.push(Routes.chat(id).path);
              },
            )
          ],
        ),
      ),
    );
  }
}
