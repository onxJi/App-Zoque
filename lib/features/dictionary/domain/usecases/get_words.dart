import '../entities/word.dart';
import '../repositories/dictionary_repository.dart';

class GetWords {
  final DictionaryRepository repository;

  GetWords(this.repository);

  Future<List<Word>> call() async {
    return await repository.getWords();
  }
}
