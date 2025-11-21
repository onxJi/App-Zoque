import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';

abstract class AdminRepository {
  // Dictionary operations
  Future<void> addWord(Word word);
  Future<void> updateWord(String id, Word word);
  Future<void> deleteWord(String id);

  // Teaching operations
  Future<void> addModule(TeachingModule module);
  Future<void> updateModule(String id, TeachingModule module);
  Future<void> deleteModule(String id);
}
