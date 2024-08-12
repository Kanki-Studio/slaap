import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slaap/providers/onboarding.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // hero image
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Image(
                  image: AssetImage('assets/images/onboarding-1.png'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // heading text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "AI Powered Multilingual Chat",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Send and receive messages in your preferred language regardless of what language the other person speaks.",
              ),
            ),
            const SizedBox(height: 24),

            // cta buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(OnBoardingProvider.provider.notifier).complete();
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
                    "Get started",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
