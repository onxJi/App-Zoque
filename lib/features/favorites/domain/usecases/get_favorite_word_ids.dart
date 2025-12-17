import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavoriteWordIds {
  final FavoritesRepository repository;

  GetFavoriteWordIds(this.repository);

  Future<List<String>> call() async {
    return await repository.getFavoriteWordIds();
  }
}
