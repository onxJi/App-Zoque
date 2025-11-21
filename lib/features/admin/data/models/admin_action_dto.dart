import 'package:appzoque/features/admin/domain/entities/admin_action.dart';

class AdminActionDTO {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String color;
  final String route;

  const AdminActionDTO({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  factory AdminActionDTO.fromJson(Map<String, dynamic> json) {
    return AdminActionDTO(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      route: json['route'] as String,
    );
  }

  AdminAction toEntity() {
    return AdminAction(
      id: id,
      title: title,
      subtitle: subtitle,
      description: subtitle, // Using subtitle as description
      icon: icon,
      color: color,
      route: route,
    );
  }
}
