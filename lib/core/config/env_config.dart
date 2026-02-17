import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'https://api.appzoque.com/v1';
  }

  static String get googleClientId {
    return dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  }

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env doesn't exist, use defaults
    }
  }
}
