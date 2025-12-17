import 'dart:math';

import 'package:appzoque/features/favorites/data/datasources/favorites_in_memory_store.dart';

class FavoritesMockDataSource {
  final FavoritesInMemoryStore store;

  static const double _toggleFailureRate = 0.1;

  FavoritesMockDataSource({required this.store});

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<List<String>> getFavoriteNewsIds() async {
    await _simulateDelay();
    print('GET /api/favorites/news - Fetching favorite news ids');
    return store.favoriteNewsIds.toList();
  }

  Future<List<String>> getFavoriteWordIds() async {
    await _simulateDelay();
    print('GET /api/favorites/words - Fetching favorite word ids');
    return store.favoriteWordIds.toList();
  }

  Future<void> addNewsFavorite(String newsId) async {
    await _simulateDelay();
    print('POST /api/favorites/news - Adding favorite news: $newsId');

    final shouldFail = Random().nextDouble() < _toggleFailureRate;
    if (shouldFail) {
      throw Exception('Simulated network error while adding favorite');
    }

    store.addNewsFavorite(newsId);
  }

  Future<void> removeNewsFavorite(String newsId) async {
    await _simulateDelay();
    print('DELETE /api/favorites/news/$newsId - Removing favorite news');

    final shouldFail = Random().nextDouble() < _toggleFailureRate;
    if (shouldFail) {
      throw Exception('Simulated network error while removing favorite');
    }

    store.removeNewsFavorite(newsId);
  }

  Future<void> addWordFavorite(String wordId) async {
    await _simulateDelay();
    print('POST /api/favorites/words - Adding favorite word: $wordId');

    final shouldFail = Random().nextDouble() < _toggleFailureRate;
    if (shouldFail) {
      throw Exception('Simulated network error while adding favorite');
    }

    store.addWordFavorite(wordId);
  }

  Future<void> removeWordFavorite(String wordId) async {
    await _simulateDelay();
    print('DELETE /api/favorites/words/$wordId - Removing favorite word');

    final shouldFail = Random().nextDouble() < _toggleFailureRate;
    if (shouldFail) {
      throw Exception('Simulated network error while removing favorite');
    }

    store.removeWordFavorite(wordId);
  }
}
