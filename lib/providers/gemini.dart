import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:slaap/env.dart';

class GeminiProvider {
  static final provider = Provider((ref) => GeminiService());
}

class GeminiService {
  final GenerativeModel model = GenerativeModel(
    model: "gemini-pro",
    apiKey: Env.geminiApiKey,
  );

  Stream<String> translateMessage({
    required String message,
    required String from,
    required String to,
  }) async* {
    final prompt = [
      Content.text("""Translate the text from $from to $to.
Text: $message"""),
    ];
    final responses = model.generateContentStream(prompt);

    await for (final response in responses) {
      yield response.text ?? "";
    }
  }
}
