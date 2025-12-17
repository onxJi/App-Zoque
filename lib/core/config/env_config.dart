import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'https://api.appzoque.com/v1';
  }

  static bool get useMockData {
    final value = dotenv.env['USE_MOCK_DATA'] ?? 'true';
    return value.toLowerCase() == 'true';
  }

  static String get googleClientId {
    return dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  }

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env doesn't exist, use defaults
      print('Warning: .env file not found, using default values');
    }
  }
}
