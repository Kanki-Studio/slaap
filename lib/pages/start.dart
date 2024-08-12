import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/models/account.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/chat.dart';
import 'package:slaap/router.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  Future<void> startChat(
    BuildContext context,
    WidgetRef ref,
    Account currentAccount,
    String email,
  ) async {
    if (email.isEmpty) return;
    try {
      final chat = await ref.read(ChatProvider.provider).startDm(
            email: email,
            currentAccount: currentAccount,
          );
      if (context.mounted) context.push(routes.chat(chat.id));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          action: SnackBarAction(
            label: "Ok",
            onPressed: () {},
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputController = TextEditingController();
    final currentAccount =
        ref.watch(AccountProvider.currentAccountProvider).requireValue!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(50),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text("Enter email address to start chat"),
                  const SizedBox(height: 12),
                  TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        hintText: "Enter email address",
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade500),
                        ),
                      ),
                      onSubmitted: (value) {
                        startChat(context, ref, currentAccount, value)
                            .then((value) => inputController.clear());
                      }),
                  const SizedBox(height: 24),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        startChat(context, ref, currentAccount,
                                inputController.text)
                            .then((value) => inputController.clear());
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(60),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Start chat",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
