import 'package:flutter/foundation.dart';

import 'package:appzoque/features/favorites/domain/usecases/add_news_favorite.dart';
import 'package:appzoque/features/favorites/domain/usecases/add_word_favorite.dart';
import 'package:appzoque/features/favorites/domain/usecases/get_favorite_news_ids.dart';
import 'package:appzoque/features/favorites/domain/usecases/get_favorite_word_ids.dart';
import 'package:appzoque/features/favorites/domain/usecases/remove_news_favorite.dart';
import 'package:appzoque/features/favorites/domain/usecases/remove_word_favorite.dart';

class FavoritesViewModel extends ChangeNotifier {
  final GetFavoriteNewsIds getFavoriteNewsIdsUseCase;
  final GetFavoriteWordIds getFavoriteWordIdsUseCase;
  final AddNewsFavorite addNewsFavoriteUseCase;
  final RemoveNewsFavorite removeNewsFavoriteUseCase;
  final AddWordFavorite addWordFavoriteUseCase;
  final RemoveWordFavorite removeWordFavoriteUseCase;

  FavoritesViewModel({
    required this.getFavoriteNewsIdsUseCase,
    required this.getFavoriteWordIdsUseCase,
    required this.addNewsFavoriteUseCase,
    required this.removeNewsFavoriteUseCase,
    required this.addWordFavoriteUseCase,
    required this.removeWordFavoriteUseCase,
  });

  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  final Set<String> _favoriteNewsIds = <String>{};
  final Set<String> _favoriteWordIds = <String>{};

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Set<String> get favoriteNewsIds => Set<String>.from(_favoriteNewsIds);
  Set<String> get favoriteWordIds => Set<String>.from(_favoriteWordIds);

  bool isNewsFavorite(String newsId) => _favoriteNewsIds.contains(newsId);
  bool isWordFavorite(String wordId) => _favoriteWordIds.contains(wordId);

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newsIds = await getFavoriteNewsIdsUseCase();
      final wordIds = await getFavoriteWordIdsUseCase();

      _favoriteNewsIds
        ..clear()
        ..addAll(newsIds);
      _favoriteWordIds
        ..clear()
        ..addAll(wordIds);
    } catch (e) {
      _error = 'Error al cargar favoritos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleNewsFavorite(String newsId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (isNewsFavorite(newsId)) {
        await removeNewsFavoriteUseCase(newsId);
        _favoriteNewsIds.remove(newsId);
        _successMessage = 'Noticia eliminada de favoritos';
      } else {
        await addNewsFavoriteUseCase(newsId);
        _favoriteNewsIds.add(newsId);
        _successMessage = 'Noticia agregada a favoritos';
      }
    } catch (e) {
      _error = 'Error al actualizar favoritos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleWordFavorite(String wordId) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (isWordFavorite(wordId)) {
        await removeWordFavoriteUseCase(wordId);
        _favoriteWordIds.remove(wordId);
        _successMessage = 'Palabra eliminada de favoritos';
      } else {
        await addWordFavoriteUseCase(wordId);
        _favoriteWordIds.add(wordId);
        _successMessage = 'Palabra agregada a favoritos';
      }
    } catch (e) {
      _error = 'Error al actualizar favoritos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
