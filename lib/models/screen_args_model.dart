class ScreenArgsModel {
  final String routeName;
  final bool isHome;
  final String? screenName;
  final Map<String, dynamic> data;

  ScreenArgsModel({
    required this.routeName,
    this.isHome = false,
    this.screenName,
    this.data = const {},
  });
}