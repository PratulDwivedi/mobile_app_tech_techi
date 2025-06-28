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
