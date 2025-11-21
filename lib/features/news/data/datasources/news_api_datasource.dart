import 'package:appzoque/features/news/domain/entities/news_item.dart';

class NewsApiDataSource {
  // TODO: Implement API calls when backend is ready

  Future<List<NewsItem>> getNews() async {
    throw UnimplementedError('API not implemented yet');
  }

  Future<List<NewsItem>> getNewsByCategory(String category) async {
    throw UnimplementedError('API not implemented yet');
  }

  Future<NewsItem?> getNewsById(String id) async {
    throw UnimplementedError('API not implemented yet');
  }
}
