import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class UpdateNews {
  final AdminRepository repository;

  UpdateNews(this.repository);

  Future<void> call(String id, NewsItem newsItem) async {
    return await repository.updateNews(id, newsItem);
  }
}
