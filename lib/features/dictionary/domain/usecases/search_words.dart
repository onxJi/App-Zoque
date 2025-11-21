import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class SearchWords {
  final DictionaryRepository repository;

  SearchWords(this.repository);

  Future<List<Word>> call(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getWords();
    }
    return await repository.searchWords(query);
  }
}
