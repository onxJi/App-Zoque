import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveNewsFavorite {
  final FavoritesRepository repository;

  RemoveNewsFavorite(this.repository);

  Future<void> call(String newsId) async {
    return await repository.removeNewsFavorite(newsId);
  }
}
