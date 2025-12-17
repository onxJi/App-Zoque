import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';

class SaveLesson {
  final AdminRepository repository;

  SaveLesson(this.repository);

  Future<void> call(String moduleId, TeachingLesson lesson) async {
    return await repository.saveLesson(moduleId, lesson);
  }
}
