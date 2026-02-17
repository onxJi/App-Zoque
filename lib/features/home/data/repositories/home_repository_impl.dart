import 'package:appzoque/features/home/data/datasources/home_api_datasource.dart';
import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';
import 'package:appzoque/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiDataSource apiDataSource;

  HomeRepositoryImpl({required this.apiDataSource});

  @override
  Future<List<HomeMenuItem>> getMenuItems(String? token) async {
    return await apiDataSource.getMenuItems(token);
  }
}
