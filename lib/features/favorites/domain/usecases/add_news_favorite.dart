import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class AddNewsFavorite {
  final FavoritesRepository repository;

  AddNewsFavorite(this.repository);

  Future<void> call(String newsId) async {
    return await repository.addNewsFavorite(newsId);
  }
}
