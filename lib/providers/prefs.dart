import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider {
  static final provider = FutureProvider(
    (ref) async {
      return await SharedPreferences.getInstance();
    },
  );

  static final instanceProvider = Provider(
    (ref) {
      return ref.watch(provider).valueOrNull;
    },
  );
}
