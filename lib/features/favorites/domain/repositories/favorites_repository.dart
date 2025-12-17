abstract class FavoritesRepository {
  Future<List<String>> getFavoriteNewsIds();
  Future<List<String>> getFavoriteWordIds();

  Future<void> addNewsFavorite(String newsId);
  Future<void> removeNewsFavorite(String newsId);

  Future<void> addWordFavorite(String wordId);
  Future<void> removeWordFavorite(String wordId);
}
