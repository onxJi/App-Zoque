import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/data/models/teaching_module_dto.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/data/datasources/teaching_in_memory_store.dart';
import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/admin/data/models/admin_action_dto.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';

class AdminMockDataSource {
  final TeachingInMemoryStore teachingStore;

  static const double _saveLessonFailureRate = 0.1;

  AdminMockDataSource({required this.teachingStore});

  // Simulate API delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _ensureTeachingModulesLoaded() async {
    if (teachingStore.modules != null) return;

    final String jsonString = await rootBundle.loadString(
      'assets/mock-data/teaching_modules.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

    final modules = jsonList
        .map((json) => TeachingModuleDTO.fromJson(json as Map<String, dynamic>))
        .map((dto) => dto.toEntity())
        .toList();

    teachingStore.setModules(modules);
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
    teachingStore.upsertModule(module);
  }

  Future<void> updateModule(String id, TeachingModule module) async {
    await _simulateDelay();
    // Simulate PUT request
    print('PUT /api/modules/$id - Updating module: ${module.title}');
    teachingStore.upsertModule(module);
  }

  Future<void> deleteModule(String id) async {
    await _simulateDelay();
    // Simulate DELETE request
    print('DELETE /api/modules/$id - Deleting module');
    teachingStore.deleteModule(id);
  }

  Future<void> saveLesson(String moduleId, TeachingLesson lesson) async {
    await _simulateDelay();
    await _ensureTeachingModulesLoaded();

    // Simulate POST request
    print(
      'POST /api/modules/$moduleId/lessons - Saving lesson: ${lesson.title}',
    );

    final shouldFail = Random().nextDouble() < _saveLessonFailureRate;
    if (shouldFail) {
      throw Exception('Simulated network error while saving lesson');
    }

    final modules = teachingStore.modules ?? <TeachingModule>[];
    final moduleIndex = modules.indexWhere((m) => m.id == moduleId);
    if (moduleIndex < 0) {
      throw Exception('Module not found: $moduleId');
    }

    final module = modules[moduleIndex];
    final lessons = List<TeachingLesson>.from(module.lessons);
    final lessonIndex = lessons.indexWhere((l) => l.id == lesson.id);
    if (lessonIndex >= 0) {
      lessons[lessonIndex] = lesson;
    } else {
      lessons.add(lesson);
    }

    final updatedModule = TeachingModule(
      id: module.id,
      title: module.title,
      titleZoque: module.titleZoque,
      description: module.description,
      imageUrl: module.imageUrl,
      level: module.level,
      lessons: lessons,
    );

    teachingStore.upsertModule(updatedModule);
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
