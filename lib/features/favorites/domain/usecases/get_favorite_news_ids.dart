import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavoriteNewsIds {
  final FavoritesRepository repository;

  GetFavoriteNewsIds(this.repository);

  Future<List<String>> call() async {
    return await repository.getFavoriteNewsIds();
  }
}
