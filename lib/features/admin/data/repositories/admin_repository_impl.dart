import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';
import 'package:appzoque/features/admin/data/datasources/admin_api_datasource.dart';
import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminApiDataSource apiDataSource;

  AdminRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<AdminAction>> getAdminActions() async {
    // Return a static list of admin actions as it's UI configuration
    return [
      AdminAction(
        id: 'dictionary',
        title: 'Diccionario',
        subtitle: 'Palabras y frases',
        description: 'Gestionar palabras del diccionario',
        icon: 'book',
        route: '/admin/manage-dictionary',
        color: 'green',
      ),
      AdminAction(
        id: 'news',
        title: 'Noticias',
        subtitle: 'Eventos y novedades',
        description: 'Gestionar noticias de la comunidad',
        icon: 'article',
        route: '/admin/manage-news',
        color: 'blue',
      ),
      AdminAction(
        id: 'teaching',
        title: 'Enseñanza',
        subtitle: 'Módulos y lecciones',
        description: 'Gestionar módulos y lecciones',
        icon: 'school',
        route: '/admin/manage-teaching',
        color: 'orange',
      ),
    ];
  }

  @override
  Future<void> addWord(Word word) async {
    return await apiDataSource.addWord(word);
  }

  @override
  Future<void> updateWord(String id, Word word) async {
    return await apiDataSource.updateWord(id, word);
  }

  @override
  Future<void> deleteWord(String id) async {
    return await apiDataSource.deleteWord(id);
  }

  @override
  Future<void> addModule(TeachingModule module) async {
    return await apiDataSource.addModule(module);
  }

  @override
  Future<void> updateModule(String id, TeachingModule module) async {
    return await apiDataSource.updateModule(id, module);
  }

  @override
  Future<void> deleteModule(String id) async {
    return await apiDataSource.deleteModule(id);
  }

  @override
  Future<void> addLesson(String moduleId, TeachingLesson lesson) async {
    return await apiDataSource.addLesson(moduleId, lesson);
  }

  @override
  Future<void> updateLesson(String id, TeachingLesson lesson) async {
    return await apiDataSource.updateLesson(id, lesson);
  }

  @override
  Future<void> deleteLesson(String id) async {
    return await apiDataSource.deleteLesson(id);
  }

  @override
  Future<void> addNews(NewsItem newsItem) async {
    return await apiDataSource.addNews(newsItem);
  }

  @override
  Future<void> updateNews(String id, NewsItem newsItem) async {
    return await apiDataSource.updateNews(id, newsItem);
  }

  @override
  Future<void> deleteNews(String id) async {
    return await apiDataSource.deleteNews(id);
  }
}
