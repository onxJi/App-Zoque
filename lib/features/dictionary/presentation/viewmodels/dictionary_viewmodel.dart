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
  bool _isLoadingMore = false;
  String? _error;
  String _searchQuery = '';

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _total = 0;
  final int _limit = 20;

  // Getters
  List<Word> get words =>
      _filteredWords.isEmpty && _searchQuery.isEmpty ? _words : _filteredWords;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasWords => words.isNotEmpty;
  String get searchQuery => _searchQuery;
  bool get hasMorePages => _currentPage < _totalPages;
  int get total => _total;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  // Load all words (first page)
  Future<void> loadWords() async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    try {
      final response = await getWords(page: _currentPage, limit: _limit);
      _words = response.data;
      _total = response.total;
      _totalPages = response.totalPages;
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

  // Load more words (next page)
  Future<void> loadMoreWords() async {
    if (_isLoadingMore || !hasMorePages || _searchQuery.isNotEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await getWords(page: nextPage, limit: _limit);
      _words.addAll(response.data);
      _currentPage = nextPage;
      _totalPages = response.totalPages;
      _total = response.total;
      _error = null;
    } catch (e) {
      _error = 'Error al cargar más palabras: $e';
    } finally {
      _isLoadingMore = false;
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
      final response = await searchWords(query, page: 1, limit: 100);
      _filteredWords = response.data;
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
