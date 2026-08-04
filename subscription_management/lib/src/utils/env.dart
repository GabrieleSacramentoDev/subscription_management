import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get varApiKey => dotenv.env['VAR_API_KEY'] ?? '';
}
