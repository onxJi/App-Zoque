import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class AddNews {
  final AdminRepository repository;

  AddNews(this.repository);

  Future<void> call(NewsItem newsItem) async {
    return await repository.addNews(newsItem);
  }
}
