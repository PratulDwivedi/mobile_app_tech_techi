import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PageItem {
  final int id;
  final String name;
  final String? descr;
  final List<PageItem> children;
  final String? itemIcon;
  final String? itemColor;
  final String routeName;
  final int displayOrder;
  final int parentPageId;
  final int displayLocationId;

  PageItem({
    required this.id,
    required this.name,
    this.descr,
    this.children = const [],
    this.itemIcon,
    this.itemColor,
    required this.routeName,
    required this.displayOrder,
    required this.parentPageId,
    required this.displayLocationId,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) {
    var childrenList = (json['children'] as List<dynamic>?)
            ?.map((child) => PageItem.fromJson(child))
            .toList() ??
        [];
    childrenList.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return PageItem(
      id: json['id'],
      name: json['name'],
      descr: json['descr'],
      children: childrenList,
      itemIcon: json['item_icon'],
      itemColor: json['item_color'],
      routeName: json['route_name'],
      displayOrder: json['display_order'],
      parentPageId: json['parent_page_id'],
      displayLocationId: json['display_location_id'],
    );
  }
}

IconData getIconFromString(String? iconName) {
  if (iconName == null) return LucideIcons.circle;
  switch (iconName) {
    case 'LayoutDashboard':
      return LucideIcons.layoutDashboard;
    case 'MessageSquare':
      return LucideIcons.messageSquare;
    case 'Home':
      return LucideIcons.home;
    case 'FileText':
      return LucideIcons.fileText;
    case 'DollarSign':
      return LucideIcons.dollarSign;
    case 'Bot':
      return LucideIcons.bot;
    case 'Key':
      return LucideIcons.key;
    case 'BookOpen':
      return LucideIcons.bookOpen;
    case 'Building':
      return LucideIcons.building;
    case 'HelpCircle':
      return LucideIcons.helpCircle;
    case 'Coins':
      return LucideIcons.coins;
    case 'Shield':
      return LucideIcons.shield;
    case 'User':
      return LucideIcons.user;
    case 'Users':
      return LucideIcons.users;
    case 'UserPlus':
      return LucideIcons.userPlus;
    case 'Package':
      return LucideIcons.package;
    case 'Clock':
      return LucideIcons.clock;
    case 'Calendar':
      return LucideIcons.calendar;
    case 'Settings':
      return LucideIcons.settings;
    case 'Globe':
      return LucideIcons.globe;
    default:
      return LucideIcons.circle;
  }
} 