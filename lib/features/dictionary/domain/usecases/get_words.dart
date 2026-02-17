import '../../../../core/models/paginated_response.dart';
import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class GetWords {
  final DictionaryRepository repository;

  GetWords(this.repository);

  Future<PaginatedResponse<Word>> call({int page = 1, int limit = 10}) async {
    return await repository.getWords(page: page, limit: limit);
  }
}
