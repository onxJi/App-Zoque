import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/admin/data/models/admin_action_dto.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';

class AdminMockDataSource {
  // Simulate API delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Get admin actions (GET request simulation)
  Future<List<AdminAction>> getAdminActions() async {
    await _simulateDelay();
    print('GET /api/admin/actions - Fetching admin actions');

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/mock-data/admin_options.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList
          .map((json) => AdminActionDTO.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error loading admin actions: $e');
    }
  }

  // Dictionary operations
  Future<void> addWord(Word word) async {
    await _simulateDelay();
    // Simulate POST request
    print('POST /api/words - Adding word: ${word.wordSpanish}');
    // In a real scenario, this would send data to the server
  }

  Future<void> updateWord(String id, Word word) async {
    await _simulateDelay();
    // Simulate PUT request
    print('PUT /api/words/$id - Updating word: ${word.wordSpanish}');
  }

  Future<void> deleteWord(String id) async {
    await _simulateDelay();
    // Simulate DELETE request
    print('DELETE /api/words/$id - Deleting word');
  }

  // Teaching operations
  Future<void> addModule(TeachingModule module) async {
    await _simulateDelay();
    // Simulate POST request
    print('POST /api/modules - Adding module: ${module.title}');
  }

  Future<void> updateModule(String id, TeachingModule module) async {
    await _simulateDelay();
    // Simulate PUT request
    print('PUT /api/modules/$id - Updating module: ${module.title}');
  }

  Future<void> deleteModule(String id) async {
    await _simulateDelay();
    // Simulate DELETE request
    print('DELETE /api/modules/$id - Deleting module');
  }

  // News operations
  Future<void> addNews(NewsItem newsItem) async {
    await _simulateDelay();
    // Simulate POST request
    print('POST /api/news - Adding news: ${newsItem.titleSpanish}');
  }

  Future<void> updateNews(String id, NewsItem newsItem) async {
    await _simulateDelay();
    // Simulate PUT request
    print('PUT /api/news/$id - Updating news: ${newsItem.titleSpanish}');
  }

  Future<void> deleteNews(String id) async {
    await _simulateDelay();
    // Simulate DELETE request
    print('DELETE /api/news/$id - Deleting news');
  }
}
