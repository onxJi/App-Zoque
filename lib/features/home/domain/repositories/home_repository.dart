import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';

abstract class HomeRepository {
  Future<List<HomeMenuItem>> getMenuItems(String? userEmail);
}
