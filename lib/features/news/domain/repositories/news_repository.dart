import 'package:appzoque/features/news/domain/entities/news_item.dart';

abstract class NewsRepository {
  Future<List<NewsItem>> getNews();
  Future<List<NewsItem>> getNewsByCategory(String category);
  Future<NewsItem?> getNewsById(String id);
}
