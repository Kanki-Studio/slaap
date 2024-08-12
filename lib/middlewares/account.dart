import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/providers/account.dart';
import 'package:slaap/providers/auth.dart';

class AccountMiddleware extends ConsumerWidget {
  final Widget child;

  const AccountMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(AccountProvider.currentAccountProvider);

    return switch (account) {
      AsyncData(:final value) => value != null ? child : errorScreen(ref),
      AsyncError() => errorScreen(ref),
      _ => const Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
    };
  }

  Scaffold errorScreen(WidgetRef ref) {
    final user = ref.watch(AuthProvider.authStateProvider).requireValue!;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(AccountProvider.provider).upsert(user);
            ref.invalidate(AccountProvider.currentAccountProvider);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 24,
            ),
          ),
          child: Text(
            "Continue as ${user.email}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
