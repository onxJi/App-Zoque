import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class AddWord {
  final AdminRepository repository;

  AddWord(this.repository);

  Future<void> call(Word word) async {
    return await repository.addWord(word);
  }
}
