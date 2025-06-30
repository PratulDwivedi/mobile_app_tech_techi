class ScreenArgsModel {
  final String routeName;
  final String pageName;
  final bool isHome;
  final Map<String, dynamic> data;

  ScreenArgsModel({
    required this.routeName,
    required this.pageName,
    this.isHome = false,
    this.data = const {},
  });
}
