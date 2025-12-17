import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';
import 'package:appzoque/features/admin/data/datasources/admin_mock_datasource.dart';
import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminMockDataSource mockDataSource;

  AdminRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<AdminAction>> getAdminActions() async {
    return await mockDataSource.getAdminActions();
  }

  @override
  Future<void> addWord(Word word) async {
    return await mockDataSource.addWord(word);
  }

  @override
  Future<void> updateWord(String id, Word word) async {
    return await mockDataSource.updateWord(id, word);
  }

  @override
  Future<void> deleteWord(String id) async {
    return await mockDataSource.deleteWord(id);
  }

  @override
  Future<void> addModule(TeachingModule module) async {
    return await mockDataSource.addModule(module);
  }

  @override
  Future<void> updateModule(String id, TeachingModule module) async {
    return await mockDataSource.updateModule(id, module);
  }

  @override
  Future<void> deleteModule(String id) async {
    return await mockDataSource.deleteModule(id);
  }

  @override
  Future<void> saveLesson(String moduleId, TeachingLesson lesson) async {
    return await mockDataSource.saveLesson(moduleId, lesson);
  }

  @override
  Future<void> addNews(NewsItem newsItem) async {
    return await mockDataSource.addNews(newsItem);
  }

  @override
  Future<void> updateNews(String id, NewsItem newsItem) async {
    return await mockDataSource.updateNews(id, newsItem);
  }

  @override
  Future<void> deleteNews(String id) async {
    return await mockDataSource.deleteNews(id);
  }
}
