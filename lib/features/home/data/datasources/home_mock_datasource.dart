import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';
import 'package:appzoque/features/home/data/models/home_menu_item_dto.dart';

class HomeMockDataSource {
  Future<List<HomeMenuItem>> getMenuItems(String? userEmail) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // 1. Get User Role
      int? userRoleId;
      if (userEmail != null) {
        final String usersJsonString = await rootBundle.loadString(
          'assets/mock-data/users.json',
        );
        final List<dynamic> usersList =
            json.decode(usersJsonString) as List<dynamic>;

        final user = usersList.firstWhere(
          (u) => u['email'] == userEmail,
          orElse: () => null,
        );

        if (user != null) {
          userRoleId = user['idRole'] as int?;
        }
      }

      // 2. Get Menu Items
      final String menuJsonString = await rootBundle.loadString(
        'assets/mock-data/menu_items.json',
      );
      final List<dynamic> menuList =
          json.decode(menuJsonString) as List<dynamic>;

      final allItems = menuList
          .map((json) => HomeMenuItemDTO.fromJson(json as Map<String, dynamic>))
          .map((dto) => dto.toEntity())
          .toList();

      // 3. Filter by Role
      // If item has no requiredRoleId, everyone can see it.
      // If item has requiredRoleId, user must have that role (or higher privileges if we had a hierarchy, but here strict equality or just existence).
      // For this requirement: "si es admin se habilita la opcion". Admin is role 1.

      return allItems.where((item) {
        if (item.requiredRoleId == null) return true;
        return userRoleId == item.requiredRoleId;
      }).toList()..sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      throw Exception('Error loading mock home data: $e');
    }
  }
}
