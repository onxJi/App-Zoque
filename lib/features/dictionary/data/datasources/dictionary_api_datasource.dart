import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/env_config.dart';
import '../../domain/entities/word.dart';
import '../models/word_dto.dart';

class DictionaryApiDataSource {
  final http.Client client;

  DictionaryApiDataSource({http.Client? client})
    : client = client ?? http.Client();

  Future<List<Word>> getWords() async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary/words');

    try {
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => WordDTO.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();
      } else {
        throw Exception('Failed to load words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching words from API: $e');
    }
  }

  Future<List<Word>> searchWords(String query) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary/search?q=$query');

    try {
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => WordDTO.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();
      } else {
        throw Exception('Failed to search words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching words from API: $e');
    }
  }

  Future<Word?> getWordById(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary/words/$id');

    try {
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

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

  Future<List<Word>> getWordsByCategory(String category) async {
    final url = Uri.parse(
      '${EnvConfig.apiBaseUrl}/dictionary/words/category/$category',
    );

    try {
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => WordDTO.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to load words by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching words by category from API: $e');
    }
  }
}
