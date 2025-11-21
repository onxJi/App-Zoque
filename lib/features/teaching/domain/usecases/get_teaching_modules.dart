import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';

class GetTeachingModules {
  final TeachingRepository repository;

  GetTeachingModules(this.repository);

  Future<List<TeachingModule>> call() async {
    return await repository.getModules();
  }
}
