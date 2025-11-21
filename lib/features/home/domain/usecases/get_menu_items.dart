import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';
import 'package:appzoque/features/home/domain/repositories/home_repository.dart';

class GetMenuItems {
  final HomeRepository repository;

  GetMenuItems(this.repository);

  Future<List<HomeMenuItem>> call(String? userEmail) async {
    return await repository.getMenuItems(userEmail);
  }
}
