import 'package:flutter/foundation.dart';
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/usecases/add_word.dart';
import 'package:appzoque/features/admin/domain/usecases/update_word.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_word.dart';
import 'package:appzoque/features/admin/domain/usecases/add_module.dart';
import 'package:appzoque/features/admin/domain/usecases/update_module.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_module.dart';

class AdminViewModel extends ChangeNotifier {
  final AddWord addWordUseCase;
  final UpdateWord updateWordUseCase;
  final DeleteWord deleteWordUseCase;
  final AddModule addModuleUseCase;
  final UpdateModule updateModuleUseCase;
  final DeleteModule deleteModuleUseCase;

  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  AdminViewModel({
    required this.addWordUseCase,
    required this.updateWordUseCase,
    required this.deleteWordUseCase,
    required this.addModuleUseCase,
    required this.updateModuleUseCase,
    required this.deleteModuleUseCase,
  });

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  // Dictionary operations
  Future<void> addWord(Word word) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await addWordUseCase(word);
      _successMessage = 'Palabra agregada exitosamente';
    } catch (e) {
      _error = 'Error al agregar palabra: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWord(String id, Word word) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await updateWordUseCase(id, word);
      _successMessage = 'Palabra actualizada exitosamente';
    } catch (e) {
      _error = 'Error al actualizar palabra: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteWord(String id) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await deleteWordUseCase(id);
      _successMessage = 'Palabra eliminada exitosamente';
    } catch (e) {
      _error = 'Error al eliminar palabra: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Teaching operations
  Future<void> addModule(TeachingModule module) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await addModuleUseCase(module);
      _successMessage = 'Módulo agregado exitosamente';
    } catch (e) {
      _error = 'Error al agregar módulo: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateModule(String id, TeachingModule module) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await updateModuleUseCase(id, module);
      _successMessage = 'Módulo actualizado exitosamente';
    } catch (e) {
      _error = 'Error al actualizar módulo: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteModule(String id) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await deleteModuleUseCase(id);
      _successMessage = 'Módulo eliminado exitosamente';
    } catch (e) {
      _error = 'Error al eliminar módulo: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
