import 'package:appzoque/features/admin/domain/entities/admin_action.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';

class GetAdminActions {
  final AdminRepository repository;

  GetAdminActions(this.repository);

  Future<List<AdminAction>> call() async {
    return await repository.getAdminActions();
  }
}
