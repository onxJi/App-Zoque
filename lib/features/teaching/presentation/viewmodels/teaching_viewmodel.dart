import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_module_by_id.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_modules.dart';
import 'package:flutter/foundation.dart';

class TeachingViewModel extends ChangeNotifier {
  final GetTeachingModules getTeachingModulesUseCase;
  final GetTeachingModuleById getTeachingModuleByIdUseCase;

  List<TeachingModule> _modules = [];
  TeachingModule? _selectedModule;
  bool _isLoading = false;
  String? _error;

  TeachingViewModel({
    required this.getTeachingModulesUseCase,
    required this.getTeachingModuleByIdUseCase,
  });

  List<TeachingModule> get modules => _modules;
  TeachingModule? get selectedModule => _selectedModule;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadModules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _modules = await getTeachingModulesUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
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
}
