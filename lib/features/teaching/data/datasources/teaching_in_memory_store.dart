import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';

class TeachingInMemoryStore {
  List<TeachingModule>? _modules;

  List<TeachingModule>? get modules => _modules;

  void setModules(List<TeachingModule> modules) {
    _modules = List<TeachingModule>.from(modules);
  }

  void upsertModule(TeachingModule module) {
    final current = _modules ?? <TeachingModule>[];
    final index = current.indexWhere((m) => m.id == module.id);
    if (index >= 0) {
      current[index] = module;
    } else {
      current.add(module);
    }
    _modules = current;
  }

  void deleteModule(String id) {
    final current = _modules ?? <TeachingModule>[];
    current.removeWhere((m) => m.id == id);
    _modules = current;
  }
}
