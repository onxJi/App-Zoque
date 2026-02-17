import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/dictionary/data/models/word_dto.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/data/models/news_item_dto.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/data/models/teaching_module_dto.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:appzoque/features/teaching/data/models/teaching_lesson_dto.dart';
import 'package:appzoque/features/auth/services/auth_service.dart';

class AdminApiDataSource {
  final http.Client client;
  final AuthService authService;

  AdminApiDataSource({http.Client? client, required this.authService})
    : client = client ?? http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getIdToken();
    if (token != null) {
      debugPrint('AUTH: Usando token en headers: ${token}...');
    } else {
      debugPrint('AUTH: No hay token disponible para los headers');
    }
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Dictionary operations
  Future<void> addWord(Word word) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary');
    final headers = await _getHeaders();

    // Actually, entities don't have toJson, so we use DTO
    final wordDto = WordDTO(
      id: '',
      wordZoque: word.wordZoque,
      wordSpanish: word.wordSpanish,
      pronunciation: word.pronunciation,
      category: word.category,
      examples: word.examples
          .map((e) => WordExampleDTO(zoque: e.zoque, spanish: e.spanish))
          .toList(),
      audioUrl: word.audioUrl,
    );

    debugPrint('API CALL: POST $url');
    final response = await client.post(
      url,
      headers: headers,
      body: json.encode(wordDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Failed to add word: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> updateWord(String id, Word word) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary/$id');
    final headers = await _getHeaders();

    final wordDto = WordDTO(
      id: id,
      wordZoque: word.wordZoque,
      wordSpanish: word.wordSpanish,
      pronunciation: word.pronunciation,
      category: word.category,
      examples: word.examples
          .map((e) => WordExampleDTO(zoque: e.zoque, spanish: e.spanish))
          .toList(),
      audioUrl: word.audioUrl,
    );

    debugPrint('API CALL: PUT $url');
    final response = await client.put(
      url,
      headers: headers,
      body: json.encode(wordDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update word: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> deleteWord(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/dictionary/$id');
    final headers = await _getHeaders();

    final response = await client.delete(url, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete word: ${response.statusCode}');
    }
  }

  // Teaching operations
  Future<void> addModule(TeachingModule module) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/teaching/module');
    final headers = await _getHeaders();

    final moduleDto = TeachingModuleDTO.fromEntity(module);

    debugPrint('API CALL: POST $url');
    final response = await client.post(
      url,
      headers: headers,
      body: json.encode(moduleDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add module: ${response.statusCode}');
    }
  }

  Future<void> updateModule(String id, TeachingModule module) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/teaching/module/$id');
    final headers = await _getHeaders();

    final moduleDto = TeachingModuleDTO.fromEntity(module);

    debugPrint('API CALL: PUT $url');
    final response = await client.put(
      url,
      headers: headers,
      body: json.encode(moduleDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 200) {
      throw Exception('Failed to update module: ${response.statusCode}');
    }
  }

  Future<void> deleteModule(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/teaching/module/$id');
    final headers = await _getHeaders();

    final response = await client.delete(url, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete module: ${response.statusCode}');
    }
  }

  Future<void> addLesson(String moduleId, TeachingLesson lesson) async {
    final url = Uri.parse(
      '${EnvConfig.apiBaseUrl}/teaching/module/$moduleId/lesson',
    );
    final headers = await _getHeaders();

    final lessonDto = TeachingLessonDTO.fromEntity(lesson);

    debugPrint('API CALL: POST $url');
    final response = await client.post(
      url,
      headers: headers,
      body: json.encode(lessonDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add lesson: ${response.statusCode}');
    }
  }

  Future<void> updateLesson(String id, TeachingLesson lesson) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/teaching/lesson/$id');
    final headers = await _getHeaders();

    final lessonDto = TeachingLessonDTO.fromEntity(lesson);

    debugPrint('API CALL: PUT $url');
    final response = await client.put(
      url,
      headers: headers,
      body: json.encode(lessonDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 200) {
      throw Exception('Failed to update lesson: ${response.statusCode}');
    }
  }

  Future<void> deleteLesson(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/teaching/lesson/$id');
    final headers = await _getHeaders();

    final response = await client.delete(url, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete lesson: ${response.statusCode}');
    }
  }

  // News operations
  Future<void> addNews(NewsItem newsItem) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/news');
    final headers = await _getHeaders();

    final newsDto = NewsItemDTO.fromEntity(newsItem);

    debugPrint('API CALL: POST $url');
    final response = await client.post(
      url,
      headers: headers,
      body: json.encode(newsDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add news: ${response.statusCode}');
    }
  }

  Future<void> updateNews(String id, NewsItem newsItem) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/news/$id');
    final headers = await _getHeaders();

    final newsDto = NewsItemDTO.fromEntity(newsItem);

    debugPrint('API CALL: PUT $url');
    final response = await client.put(
      url,
      headers: headers,
      body: json.encode(newsDto.toJson()),
    );
    debugPrint('API RESPONSE: ${response.statusCode} from $url');

    if (response.statusCode != 200) {
      throw Exception('Failed to update news: ${response.statusCode}');
    }
  }

  Future<void> deleteNews(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/news/$id');
    final headers = await _getHeaders();

    final response = await client.delete(url, headers: headers);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete news: ${response.statusCode}');
    }
  }
}
