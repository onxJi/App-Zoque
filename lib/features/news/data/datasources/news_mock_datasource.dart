import 'dart:convert';
import 'package:appzoque/features/news/data/models/news_item_dto.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:flutter/services.dart' show rootBundle;

class NewsMockDataSource {
  Future<List<NewsItem>> getNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/mock-data/news_items.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList
          .map((json) => NewsItemDTO.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error loading mock news data: $e');
    }
  }

  Future<List<NewsItem>> getNewsByCategory(String category) async {
    final allNews = await getNews();
    return allNews
        .where((news) => news.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<NewsItem?> getNewsById(String id) async {
    final allNews = await getNews();
    try {
      return allNews.firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }
}
