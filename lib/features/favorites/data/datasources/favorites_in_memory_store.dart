class FavoritesInMemoryStore {
  final Set<String> _favoriteNewsIds = <String>{};
  final Set<String> _favoriteWordIds = <String>{};

  Set<String> get favoriteNewsIds => Set<String>.from(_favoriteNewsIds);
  Set<String> get favoriteWordIds => Set<String>.from(_favoriteWordIds);

  bool isNewsFavorite(String newsId) => _favoriteNewsIds.contains(newsId);
  bool isWordFavorite(String wordId) => _favoriteWordIds.contains(wordId);

  void setFavoriteNewsIds(Iterable<String> ids) {
    _favoriteNewsIds
      ..clear()
      ..addAll(ids);
  }

  void setFavoriteWordIds(Iterable<String> ids) {
    _favoriteWordIds
      ..clear()
      ..addAll(ids);
  }

  void addNewsFavorite(String newsId) {
    _favoriteNewsIds.add(newsId);
  }

  void removeNewsFavorite(String newsId) {
    _favoriteNewsIds.remove(newsId);
  }

  void addWordFavorite(String wordId) {
    _favoriteWordIds.add(wordId);
  }

  void removeWordFavorite(String wordId) {
    _favoriteWordIds.remove(wordId);
  }
}
