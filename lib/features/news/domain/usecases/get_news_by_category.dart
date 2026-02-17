import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class GetNewsByCategory {
  final NewsRepository repository;

  GetNewsByCategory(this.repository);

  Future<PaginatedResponse<NewsItem>> call(
    String category, {
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getNewsByCategory(
      category,
      page: page,
      limit: limit,
    );
  }
}
