import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<PaginatedResponse<NewsItem>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getNews(page: page, limit: limit);
  }
}
