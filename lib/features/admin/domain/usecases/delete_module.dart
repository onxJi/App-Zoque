import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class DeleteModule {
  final AdminRepository repository;

  DeleteModule(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteModule(id);
  }
}
