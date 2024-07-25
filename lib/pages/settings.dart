import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slaap/router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Settings"),
            MaterialButton(
              child: const Text("Go to profile settings"),
              onPressed: () {
                context.push(Routes.settingsProfile().path);
              },
            ),
          ],
        ),
      ),
    );
  }
}
