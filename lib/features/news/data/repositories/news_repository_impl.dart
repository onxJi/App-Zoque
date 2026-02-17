import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/news/data/datasources/news_api_datasource.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDataSource apiDataSource;

  NewsRepositoryImpl({required this.apiDataSource});

  @override
  Future<PaginatedResponse<NewsItem>> getNews({
    int page = 1,
    int limit = 10,
  }) async {
    return await apiDataSource.getNews(page: page, limit: limit);
  }

  @override
  Future<PaginatedResponse<NewsItem>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 10,
  }) async {
    return await apiDataSource.getNewsByCategory(
      category,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<NewsItem?> getNewsById(String id) async {
    return await apiDataSource.getNewsById(id);
  }
}
