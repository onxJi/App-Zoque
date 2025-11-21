class HomeMenuItem {
  final String id;
  final String label;
  final String icon;
  final String activeIcon;
  final String route;
  final int? requiredRoleId;
  final int order;

  const HomeMenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.requiredRoleId,
    required this.order,
  });
}
