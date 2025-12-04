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

  // Store all items to support local filtering/search
  List<NewsItem> _allNewsItems = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  List<String> get categories {
    final categorySet = _allNewsItems.map((item) => item.category).toSet();
    return categorySet.toList()..sort();
  }

  Future<void> loadNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allNewsItems = await getNewsUseCase();
      _newsItems = List.from(_allNewsItems);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (category == null || category.isEmpty) {
        _allNewsItems = await getNewsUseCase();
      } else {
        _allNewsItems = await getNewsByCategoryUseCase(category);
      }
      _newsItems = List.from(_allNewsItems);
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
