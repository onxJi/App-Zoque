import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveWordFavorite {
  final FavoritesRepository repository;

  RemoveWordFavorite(this.repository);

  Future<void> call(String wordId) async {
    return await repository.removeWordFavorite(wordId);
  }
}
