import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class DeleteLesson {
  final AdminRepository repository;

  DeleteLesson(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteLesson(id);
  }
}
