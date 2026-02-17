import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';

abstract class NewsRepository {
  Future<PaginatedResponse<NewsItem>> getNews({int page = 1, int limit = 10});
  Future<PaginatedResponse<NewsItem>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 10,
  });
  Future<NewsItem?> getNewsById(String id);
}
