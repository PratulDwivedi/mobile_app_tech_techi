class ScreenArgsModel {
  final String routeName;
  final String pageName;
  final bool isHome;
  final String? screenName;
  final Map<String, dynamic> data;

  ScreenArgsModel({
    required this.routeName,
    required this.pageName,
    this.isHome = false,
    this.screenName,
    this.data = const {},
  });
}
