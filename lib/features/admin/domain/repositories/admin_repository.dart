import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';

abstract class AdminRepository {
  // Admin options
  Future<List<AdminAction>> getAdminActions();

  // Dictionary operations
  Future<void> addWord(Word word);
  Future<void> updateWord(String id, Word word);
  Future<void> deleteWord(String id);

  // Teaching operations
  Future<void> addModule(TeachingModule module);
  Future<void> updateModule(String id, TeachingModule module);
  Future<void> deleteModule(String id);

  // News operations
  Future<void> addNews(NewsItem newsItem);
  Future<void> updateNews(String id, NewsItem newsItem);
  Future<void> deleteNews(String id);
}
