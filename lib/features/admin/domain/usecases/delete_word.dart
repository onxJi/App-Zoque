import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class DeleteWord {
  final AdminRepository repository;

  DeleteWord(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteWord(id);
  }
}
