import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class AddWordFavorite {
  final FavoritesRepository repository;

  AddWordFavorite(this.repository);

  Future<void> call(String wordId) async {
    return await repository.addWordFavorite(wordId);
  }
}
