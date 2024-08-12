import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  static Future<void> init() => dotenv.load();

  static String get geminiApiKey => dotenv.env["GEMINI_API_KEY"]!;
}
