import 'package:flutter/material.dart';
import '../../domain/entities/word.dart';
import '../../domain/usecases/get_words.dart';
import '../../domain/usecases/search_words.dart';

class DictionaryViewModel extends ChangeNotifier {
  final GetWords getWords;
  final SearchWords searchWords;

  DictionaryViewModel({required this.getWords, required this.searchWords});

  // State
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Word> get words =>
      _filteredWords.isEmpty && _searchQuery.isEmpty ? _words : _filteredWords;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasWords => words.isNotEmpty;
  String get searchQuery => _searchQuery;

  // Load all words
  Future<void> loadWords() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _words = await getWords();
      _filteredWords = [];
      _searchQuery = '';
      _error = null;
    } catch (e) {
      _error = 'Error al cargar palabras: $e';
      _words = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search words
  Future<void> search(String query) async {
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _filteredWords = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _filteredWords = await searchWords(query);
      _error = null;
    } catch (e) {
      _error = 'Error al buscar palabras: $e';
      _filteredWords = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredWords = [];
    notifyListeners();
  }

  // Get word by ID
  Word? getWordById(String id) {
    try {
      return _words.firstWhere((word) => word.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get unique categories
  List<String> get categories {
    final categorySet = <String>{};
    for (final word in _words) {
      categorySet.add(word.category);
    }
    return categorySet.toList()..sort();
  }
}
