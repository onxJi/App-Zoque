import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/home_menu_item.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<HomeMenuItem> menuItems;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: menuItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(_getIconData(item.icon)),
            activeIcon: Icon(_getIconData(item.activeIcon)),
            label: item.label,
          );
        }).toList(),
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: onTap,
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'article_outlined':
        return Icons.article_outlined;
      case 'article':
        return Icons.article;
      case 'school_outlined':
        return Icons.school_outlined;
      case 'school':
        return Icons.school;
      case 'menu_book_outlined':
        return Icons.menu_book_outlined;
      case 'menu_book':
        return Icons.menu_book;
      case 'admin_panel_settings_outlined':
        return Icons.admin_panel_settings_outlined;
      case 'admin_panel_settings':
        return Icons.admin_panel_settings;
      default:
        return Icons.circle;
    }
  }
}
