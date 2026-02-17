import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';

class UpdateLesson {
  final AdminRepository repository;

  UpdateLesson(this.repository);

  Future<void> call(String id, TeachingLesson lesson) async {
    return await repository.updateLesson(id, lesson);
  }
}
