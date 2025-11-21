import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class UpdateModule {
  final AdminRepository repository;

  UpdateModule(this.repository);

  Future<void> call(String id, TeachingModule module) async {
    return await repository.updateModule(id, module);
  }
}
