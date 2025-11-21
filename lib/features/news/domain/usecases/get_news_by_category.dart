import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class GetNewsByCategory {
  final NewsRepository repository;

  GetNewsByCategory(this.repository);

  Future<List<NewsItem>> call(String category) async {
    return await repository.getNewsByCategory(category);
  }
}
