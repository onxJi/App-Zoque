import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/usecases/get_news.dart';
import 'package:appzoque/features/news/domain/usecases/get_news_by_category.dart';
import 'package:appzoque/features/news/domain/usecases/get_news_by_id.dart';
import 'package:flutter/foundation.dart';

class NewsViewModel extends ChangeNotifier {
  final GetNews getNewsUseCase;
  final GetNewsByCategory getNewsByCategoryUseCase;
  final GetNewsById getNewsByIdUseCase;

  NewsViewModel({
    required this.getNewsUseCase,
    required this.getNewsByCategoryUseCase,
    required this.getNewsByIdUseCase,
  });

  List<NewsItem> _newsItems = [];
  List<NewsItem> get newsItems => _newsItems;

  List<NewsItem> _allNewsItems = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String? _error;
  String? get error => _error;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _limit = 10;

  bool get hasMorePages => _currentPage < _totalPages;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;

  List<String> get categories {
    final categorySet = _allNewsItems.map((item) => item.category).toSet();
    return categorySet.toList()..sort();
  }

  Future<void> loadNews({bool refresh = true}) async {
    if (refresh) {
      _currentPage = 1;
      _isLoading = true;
    } else {
      if (!hasMorePages || _isLoadingMore) return;
      _isLoadingMore = true;
    }

    _error = null;
    notifyListeners();

    try {
      final response = await getNewsUseCase(
        page: refresh ? 1 : _currentPage + 1,
        limit: _limit,
      );

      if (refresh) {
        _allNewsItems = response.data;
        _newsItems = List.from(_allNewsItems);
      } else {
        // Filter out items already in the list to avoid duplicates
        final existingIds = _allNewsItems.map((n) => n.id).toSet();
        final newItems = response.data.where(
          (n) => !existingIds.contains(n.id),
        );

        _allNewsItems.addAll(newItems);
        _newsItems = List.from(_allNewsItems);
        _currentPage++;
      }

      _totalCount = response.total;
      _totalPages = response.totalPages;

      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    _currentPage = 1;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = (category == null || category.isEmpty)
          ? await getNewsUseCase(page: 1, limit: _limit)
          : await getNewsByCategoryUseCase(category, page: 1, limit: _limit);

      _allNewsItems = response.data;
      _newsItems = List.from(_allNewsItems);
      _totalCount = response.total;
      _totalPages = response.totalPages;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchNews(String query) {
    if (query.isEmpty) {
      _newsItems = List.from(_allNewsItems);
    } else {
      final lowercaseQuery = query.toLowerCase();
      _newsItems = _allNewsItems.where((item) {
        return item.titleSpanish.toLowerCase().contains(lowercaseQuery) ||
            item.titleZoque.toLowerCase().contains(lowercaseQuery) ||
            item.description.toLowerCase().contains(lowercaseQuery) ||
            item.category.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
  }

  Future<NewsItem?> getNewsItemById(String id) async {
    try {
      return await getNewsByIdUseCase(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
