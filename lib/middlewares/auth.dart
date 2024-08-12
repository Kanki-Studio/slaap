import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/providers/auth.dart';

class AuthMiddleware extends ConsumerWidget {
  final Widget child;

  const AuthMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(AuthProvider.authStateProvider);

    return switch (user) {
      AsyncData(:final value) =>
        value != null ? child : waitingScreen(const Text("Unauthenticated")),
      AsyncError() => waitingScreen(const Text("Unauthenticated")),
      _ => waitingScreen(const CupertinoActivityIndicator()),
    };
  }

  Scaffold waitingScreen(Widget child) {
    return Scaffold(
      body: Center(child: child),
    );
  }
}
