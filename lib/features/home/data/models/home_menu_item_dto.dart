import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';

class HomeMenuItemDTO {
  final String id;
  final String label;
  final String icon;
  final String activeIcon;
  final String route;
  final int? requiredRoleId;
  final int order;

  const HomeMenuItemDTO({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.requiredRoleId,
    required this.order,
  });

  factory HomeMenuItemDTO.fromJson(Map<String, dynamic> json) {
    return HomeMenuItemDTO(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      activeIcon: json['activeIcon'] as String,
      route: json['route'] as String,
      requiredRoleId: json['requiredRoleId'] as int?,
      order: json['order'] as int,
    );
  }

  HomeMenuItem toEntity() {
    return HomeMenuItem(
      id: id,
      label: label,
      icon: icon,
      activeIcon: activeIcon,
      route: route,
      requiredRoleId: requiredRoleId,
      order: order,
    );
  }
}
