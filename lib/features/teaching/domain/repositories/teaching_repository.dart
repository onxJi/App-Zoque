import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';

abstract class TeachingRepository {
  Future<List<TeachingModule>> getModules();
  Future<TeachingModule?> getModuleById(String id);
}
