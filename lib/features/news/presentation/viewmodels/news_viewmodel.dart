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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  List<String> get categories {
    final categorySet = _newsItems.map((item) => item.category).toSet();
    return categorySet.toList()..sort();
  }

  Future<void> loadNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _newsItems = await getNewsUseCase();
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
        _newsItems = await getNewsUseCase();
      } else {
        _newsItems = await getNewsByCategoryUseCase(category);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
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
