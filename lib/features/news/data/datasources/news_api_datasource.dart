import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/news/data/models/news_item_dto.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:flutter/foundation.dart';

class NewsApiDataSource {
  final http.Client client;

  NewsApiDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<PaginatedResponse<NewsItem>> getNews({
    int page = 1,
    int limit = 10,
  }) async {
    final url = Uri.parse(
      '${EnvConfig.apiBaseUrl}/news?page=$page&limit=$limit',
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
          (json) => NewsItemDTO.fromJson(json).toEntity(),
        );
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news from API: $e');
    }
  }

  Future<PaginatedResponse<NewsItem>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 10,
  }) async {
    // Note: The API doesn't have a specific category filter endpoint
    // We'll fetch all and filter client-side for now
    final response = await getNews(page: page, limit: 1000);
    final filteredData = response.data
        .where((news) => news.category.toLowerCase() == category.toLowerCase())
        .toList();

    return PaginatedResponse(
      data: filteredData,
      total: filteredData.length,
      page: 1,
      limit: filteredData.length,
      totalPages: 1,
    );
  }

  Future<NewsItem?> getNewsById(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/news/$id');

    try {
      debugPrint('API CALL: GET $url');
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return NewsItemDTO.fromJson(json).toEntity();
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load news item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news item from API: $e');
    }
  }
}
