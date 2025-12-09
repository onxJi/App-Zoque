import 'package:appzoque/features/auth/data/datasources/admin_auth_datasource.dart';

abstract class AdminAuthRepository {
  Future<bool> verifyAdminUser(String idToken);
}

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final AdminAuthDataSource dataSource;

  AdminAuthRepositoryImpl({required this.dataSource});

  @override
  Future<bool> verifyAdminUser(String idToken) async {
    try {
      return await dataSource.verifyAdminUser(idToken);
    } catch (e) {
      print('Error en AdminAuthRepository: $e');
      rethrow;
    }
  }
}
