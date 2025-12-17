import 'package:appzoque/features/favorites/data/datasources/favorites_mock_datasource.dart';
import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesMockDataSource mockDataSource;

  FavoritesRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<String>> getFavoriteNewsIds() async {
    return await mockDataSource.getFavoriteNewsIds();
  }

  @override
  Future<List<String>> getFavoriteWordIds() async {
    return await mockDataSource.getFavoriteWordIds();
  }

  @override
  Future<void> addNewsFavorite(String newsId) async {
    return await mockDataSource.addNewsFavorite(newsId);
  }

  @override
  Future<void> removeNewsFavorite(String newsId) async {
    return await mockDataSource.removeNewsFavorite(newsId);
  }

  @override
  Future<void> addWordFavorite(String wordId) async {
    return await mockDataSource.addWordFavorite(wordId);
  }

  @override
  Future<void> removeWordFavorite(String wordId) async {
    return await mockDataSource.removeWordFavorite(wordId);
  }
}
