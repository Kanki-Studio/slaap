import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider {
  static final provider = AsyncNotifierProvider<OnboardingNotifier, bool>(() {
    return OnboardingNotifier();
  });
}

class OnboardingNotifier extends AsyncNotifier<bool> {
  static const onboardedStateKey = "onboarded";

  late final SharedPreferences prefs;

  @override
  Future<bool> build() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardedStateKey) ?? false;
  }

  Future<void> complete() async {
    await prefs.setBool(onboardedStateKey, true);
    state = const AsyncValue.data(true);
  }

  Future<void> reset() async {
    await prefs.setBool(onboardedStateKey, false);
    state = const AsyncValue.data(false);
  }
}
