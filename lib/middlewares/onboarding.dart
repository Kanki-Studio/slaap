import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/providers/onboarding.dart';

class OnboardingMiddleware extends ConsumerWidget {
  final Widget child;

  const OnboardingMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded =
        ref.watch(OnBoardingProvider.provider).valueOrNull ?? false;

    return onboarded
        ? child
        : const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
  }
}
