import '../../../../core/models/paginated_response.dart';
import '../../domain/entities/word.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_api_datasource.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryApiDataSource apiDataSource;

  DictionaryRepositoryImpl({required this.apiDataSource});

  @override
  Future<PaginatedResponse<Word>> getWords({
    int page = 1,
    int limit = 10,
  }) async {
    return await apiDataSource.getWords(page: page, limit: limit);
  }

  @override
  Future<PaginatedResponse<Word>> searchWords(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    return await apiDataSource.searchWords(query, page: page, limit: limit);
  }

  @override
  Future<Word?> getWordById(String id) async {
    return await apiDataSource.getWordById(id);
  }

  @override
  Future<List<Word>> getWordsByCategory(String category) async {
    return await apiDataSource.getWordsByCategory(category);
  }
}
