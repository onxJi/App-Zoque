import '../entities/word.dart';

abstract class DictionaryRepository {
  /// Get all words from the dictionary
  Future<List<Word>> getWords();

  /// Search words by query (searches in both Zoque and Spanish)
  Future<List<Word>> searchWords(String query);

  /// Get a single word by ID
  Future<Word?> getWordById(String id);

  /// Get words by category
  Future<List<Word>> getWordsByCategory(String category);
}
