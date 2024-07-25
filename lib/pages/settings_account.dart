import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/router.dart';

class SettingsAccountPage extends ConsumerWidget {
  const SettingsAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Account settings"),
            MaterialButton(
              child: const Text("Go to settings"),
              onPressed: () => context.go(Routes.settings().path),
            ),
          ],
        ),
      ),
    );
  }
}
