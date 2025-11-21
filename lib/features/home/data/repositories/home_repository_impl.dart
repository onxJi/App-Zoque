import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';
import 'package:appzoque/features/home/domain/repositories/home_repository.dart';
import 'package:appzoque/features/home/data/datasources/home_mock_datasource.dart';
import 'package:appzoque/core/config/env_config.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeMockDataSource mockDataSource;
  // Add apiDataSource when ready

  HomeRepositoryImpl({required this.mockDataSource});

  bool get _useMockData => EnvConfig.useMockData;

  @override
  Future<List<HomeMenuItem>> getMenuItems(String? userEmail) async {
    if (_useMockData) {
      return await mockDataSource.getMenuItems(userEmail);
    } else {
      // Fallback or implement API call
      return await mockDataSource.getMenuItems(userEmail);
    }
  }
}
