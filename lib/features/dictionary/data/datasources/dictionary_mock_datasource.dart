import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/word.dart';
import '../models/word_dto.dart';

class DictionaryMockDataSource {
  Future<List<Word>> getWords() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/mock-data/dictionary_words.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList
          .map((json) => WordDTO.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error loading mock data: $e');
    }
  }

  Future<List<Word>> searchWords(String query) async {
    final allWords = await getWords();
    final lowercaseQuery = query.toLowerCase();

    return allWords.where((word) {
      return word.wordZoque.toLowerCase().contains(lowercaseQuery) ||
          word.wordSpanish.toLowerCase().contains(lowercaseQuery) ||
          word.pronunciation.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<Word?> getWordById(String id) async {
    final allWords = await getWords();
    try {
      return allWords.firstWhere((word) => word.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Word>> getWordsByCategory(String category) async {
    final allWords = await getWords();
    return allWords
        .where((word) => word.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
