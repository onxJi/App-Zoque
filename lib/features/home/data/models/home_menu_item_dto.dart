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
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      activeIcon: json['activeIcon']?.toString() ?? '',
      route: json['route']?.toString() ?? '',
      requiredRoleId: _toInt(json['requiredRoleId']),
      order: _toInt(json['order']) ?? 0,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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
