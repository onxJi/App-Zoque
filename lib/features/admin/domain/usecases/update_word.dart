import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class UpdateWord {
  final AdminRepository repository;

  UpdateWord(this.repository);

  Future<void> call(String id, Word word) async {
    return await repository.updateWord(id, word);
  }
}
