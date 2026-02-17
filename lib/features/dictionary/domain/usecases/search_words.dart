import '../../../../core/models/paginated_response.dart';
import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class SearchWords {
  final DictionaryRepository repository;

  SearchWords(this.repository);

  Future<PaginatedResponse<Word>> call(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return await repository.getWords(page: page, limit: limit);
    }
    return await repository.searchWords(query, page: page, limit: limit);
  }
}
