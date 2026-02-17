import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/env_config.dart';
import '../../../../core/models/paginated_response.dart';
import '../../domain/entities/word.dart';
import '../models/word_dto.dart';

class DictionaryApiDataSource {
  final http.Client client;

  DictionaryApiDataSource({http.Client? client})
    : client = client ?? http.Client();

  Future<PaginatedResponse<Word>> getWords({
    int page = 1,
    int limit = 10,
  }) async {
    final url = Uri.parse(
      '${EnvConfig.apiBaseUrl}/dictionary?page=$page&limit=$limit',
    );

    try {
      debugPrint('API CALL: GET $url');
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return PaginatedResponse.fromJson(
          jsonResponse,
          (json) => WordDTO.fromJson(json).toEntity(),
        );
      } else {
        throw Exception('Failed to load words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching words from API: $e');
    }
  }

  Future<PaginatedResponse<Word>> searchWords(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    final url = Uri.parse(
      '${EnvConfig.apiBaseUrl}/dictionary?search=$query&page=$page&limit=$limit',
    );

    try {
      debugPrint('API CALL: GET $url');
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return PaginatedResponse.fromJson(
          jsonResponse,
          (json) => WordDTO.fromJson(json).toEntity(),
        );
      } else {
        throw Exception('Failed to search words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching words from API: $e');
    }
  }

  Future<Word?> getWordById(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary/$id');

    try {
      debugPrint('API CALL: GET $url');
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WordDTO.fromJson(json).toEntity();
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load word: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching word from API: $e');
    }
  }

  // Note: The API doesn't have a specific endpoint for category filtering
  // This would need to be done client-side or the backend needs to add this endpoint
  Future<List<Word>> getWordsByCategory(String category) async {
    // For now, we'll fetch all words and filter client-side
    // This is not optimal for large datasets
    final response = await getWords(limit: 1000); // Get a large batch
    return response.data
        .where((word) => word.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
