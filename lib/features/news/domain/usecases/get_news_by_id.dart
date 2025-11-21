import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class GetNewsById {
  final NewsRepository repository;

  GetNewsById(this.repository);

  Future<NewsItem?> call(String id) async {
    return await repository.getNewsById(id);
  }
}
