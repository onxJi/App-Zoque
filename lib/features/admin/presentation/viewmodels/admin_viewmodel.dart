import 'package:flutter/foundation.dart';
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/admin/domain/usecases/get_admin_actions.dart';
import 'package:appzoque/features/admin/domain/usecases/add_word.dart';
import 'package:appzoque/features/admin/domain/usecases/update_word.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_word.dart';
import 'package:appzoque/features/admin/domain/usecases/add_module.dart';
import 'package:appzoque/features/admin/domain/usecases/update_module.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_module.dart';
import 'package:appzoque/features/admin/domain/usecases/save_lesson.dart';
import 'package:appzoque/features/admin/domain/usecases/add_news.dart';
import 'package:appzoque/features/admin/domain/usecases/update_news.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_news.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';

class AdminViewModel extends ChangeNotifier {
  final GetAdminActions getAdminActionsUseCase;
  final AddWord addWordUseCase;
  final UpdateWord updateWordUseCase;
  final DeleteWord deleteWordUseCase;
  final AddModule addModuleUseCase;
  final UpdateModule updateModuleUseCase;
  final DeleteModule deleteModuleUseCase;
  final SaveLesson saveLessonUseCase;
  final AddNews addNewsUseCase;
  final UpdateNews updateNewsUseCase;
  final DeleteNews deleteNewsUseCase;

  List<AdminAction> _adminActions = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  AdminViewModel({
    required this.getAdminActionsUseCase,
    required this.addWordUseCase,
    required this.updateWordUseCase,
    required this.deleteWordUseCase,
    required this.addModuleUseCase,
    required this.updateModuleUseCase,
    required this.deleteModuleUseCase,
    required this.saveLessonUseCase,
    required this.addNewsUseCase,
    required this.updateNewsUseCase,
    required this.deleteNewsUseCase,
  });

  List<AdminAction> get adminActions => _adminActions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> saveLesson(String moduleId, TeachingLesson lesson) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await saveLessonUseCase(moduleId, lesson);
      _successMessage = 'Lección guardada exitosamente';
    } catch (e) {
      _error = 'Error al guardar lección: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load admin actions
  Future<void> loadAdminActions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _adminActions = await getAdminActionsUseCase();
    } catch (e) {
      _error = 'Error al cargar opciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  // News operations
  Future<void> addNews(NewsItem newsItem) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await addNewsUseCase(newsItem);
      _successMessage = 'Noticia publicada exitosamente';
    } catch (e) {
      _error = 'Error al publicar noticia: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNews(String id, NewsItem newsItem) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await updateNewsUseCase(id, newsItem);
      _successMessage = 'Noticia actualizada exitosamente';
    } catch (e) {
      _error = 'Error al actualizar noticia: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNews(String id) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      await deleteNewsUseCase(id);
      _successMessage = 'Noticia eliminada exitosamente';
    } catch (e) {
      _error = 'Error al eliminar noticia: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
