import 'package:appzoque/features/teaching/data/datasources/teaching_mock_datasource.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';
import 'package:appzoque/core/config/env_config.dart';

class TeachingRepositoryImpl implements TeachingRepository {
  final TeachingMockDataSource mockDataSource;
  // Add apiDataSource when ready

  TeachingRepositoryImpl({required this.mockDataSource});

  bool get _useMockData => EnvConfig.useMockData;

  @override
  Future<List<TeachingModule>> getModules() async {
    if (_useMockData) {
      return await mockDataSource.getModules();
    } else {
      // Fallback or implement API call
      return await mockDataSource.getModules();
    }
  }

  @override
  Future<TeachingModule?> getModuleById(String id) async {
    if (_useMockData) {
      return await mockDataSource.getModuleById(id);
    } else {
      // Fallback or implement API call
      return await mockDataSource.getModuleById(id);
    }
  }
}
