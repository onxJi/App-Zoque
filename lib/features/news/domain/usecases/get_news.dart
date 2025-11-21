import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsItem>> call() async {
    return await repository.getNews();
  }
}
