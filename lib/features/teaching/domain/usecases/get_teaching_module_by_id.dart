import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';

class GetTeachingModuleById {
  final TeachingRepository repository;

  GetTeachingModuleById(this.repository);

  Future<TeachingModule?> call(String id) async {
    return await repository.getModuleById(id);
  }
}
