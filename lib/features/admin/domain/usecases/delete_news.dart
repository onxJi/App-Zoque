import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class DeleteNews {
  final AdminRepository repository;

  DeleteNews(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteNews(id);
  }
}
