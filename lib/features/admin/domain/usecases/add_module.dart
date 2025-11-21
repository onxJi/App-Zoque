import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class AddModule {
  final AdminRepository repository;

  AddModule(this.repository);

  Future<void> call(TeachingModule module) async {
    return await repository.addModule(module);
  }
}
