import '../../../../core/models/paginated_response.dart';
import '../entities/word.dart';

abstract class DictionaryRepository {
  /// Get all words from the dictionary with pagination
  Future<PaginatedResponse<Word>> getWords({int page = 1, int limit = 10});

  /// Search words by query (searches in both Zoque and Spanish) with pagination
  Future<PaginatedResponse<Word>> searchWords(
    String query, {
    int page = 1,
    int limit = 10,
  });

  /// Get a single word by ID
  Future<Word?> getWordById(String id);

  /// Get words by category
  Future<List<Word>> getWordsByCategory(String category);
}
