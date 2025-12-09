import 'package:appzoque/features/auth/data/repositories/admin_auth_repository_impl.dart';

class VerifyAdminUserUseCase {
  final AdminAuthRepository repository;

  VerifyAdminUserUseCase({required this.repository});

  Future<bool> call(String idToken) async {
    return await repository.verifyAdminUser(idToken);
  }
}
