import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_module_by_id.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_modules.dart';
import 'package:flutter/foundation.dart';

class TeachingViewModel extends ChangeNotifier {
  final GetTeachingModules getTeachingModulesUseCase;
  final GetTeachingModuleById getTeachingModuleByIdUseCase;

  TeachingViewModel({
    required this.getTeachingModulesUseCase,
    required this.getTeachingModuleByIdUseCase,
  });

  List<TeachingModule> _modules = [];
  TeachingModule? _selectedModule;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String _searchQuery = '';

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _limit = 10;

  List<TeachingModule> get modules {
    if (_searchQuery.isEmpty) return _modules;
    final query = _searchQuery.toLowerCase();
    return _modules.where((m) {
      return m.title.toLowerCase().contains(query) ||
          m.titleZoque.toLowerCase().contains(query) ||
          m.description.toLowerCase().contains(query);
    }).toList();
  }

  TeachingModule? get selectedModule => _selectedModule;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  bool get hasMorePages => _currentPage < _totalPages;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;

  Future<void> loadModules({bool refresh = true}) async {
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
      final response = await getTeachingModulesUseCase(
        page: refresh ? 1 : _currentPage + 1,
        limit: _limit,
      );

      if (refresh) {
        _modules = response.data;
      } else {
        _modules.addAll(response.data);
        _currentPage++;
      }

      _totalCount = response.total;
      _totalPages = response.totalPages;

      _isLoading = false;
      _isLoadingMore = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoadingMore = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadModuleById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedModule = await getTeachingModuleByIdUseCase(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedModule() {
    _selectedModule = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
