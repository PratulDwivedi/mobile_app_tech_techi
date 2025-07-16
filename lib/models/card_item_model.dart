
class CardItemModel {
  final String url;
  final String title;
  final String value;
  final String itemIcon;
  final String subTitle;
  final String subTitle2;
  final String iconSymbol;

  CardItemModel({
    required this.url,
    required this.title,
    required this.value,
    required this.itemIcon,
    required this.subTitle,
    required this.subTitle2,
    required this.iconSymbol,
  });

  factory CardItemModel.fromJson(Map<String, dynamic> json) {
    return CardItemModel(
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      value: json['value'] ?? '',
      itemIcon: json['item_icon'] ?? '',
      subTitle: json['sub_title'] ?? '',
      subTitle2: json['sub_title2'] ?? '',
      iconSymbol: json['icon_symbol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'value': value,
      'item_icon': itemIcon,
      'sub_title': subTitle,
      'sub_title2': subTitle2,
      'icon_symbol': iconSymbol,
    };
  }
}