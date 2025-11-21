import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';
import 'package:appzoque/features/home/domain/usecases/get_menu_items.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  final GetMenuItems getMenuItemsUseCase;

  HomeViewModel({required this.getMenuItemsUseCase});

  List<HomeMenuItem> _menuItems = [];
  List<HomeMenuItem> get menuItems => _menuItems;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> loadMenuItems(String? userEmail) async {
    _isLoading = true;
    notifyListeners();

    try {
      _menuItems = await getMenuItemsUseCase(userEmail);
    } catch (e) {
      debugPrint('Error loading menu items: $e');
      // Handle error appropriately, maybe set empty list or default items
      _menuItems = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
