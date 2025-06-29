import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/screens/chat_screen.dart';
import 'package:mobile_app_tech_techi/screens/dynamic_screen.dart';
import '../models/screen_args_model.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final Map<String, WidgetBuilder> _routes = {
    'chat': (context) => const ChatScreen(),
    // Add other fixed routes here
  };

  static void navigateTo(String routeName, {Object? arguments}) {
    if (_routes.containsKey(routeName)) {
      navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
    } else {
      ScreenArgsModel args;
      if (arguments is ScreenArgsModel) {
        args = arguments;
      } else if (arguments is Map<String, dynamic>) {
        args = ScreenArgsModel(
            routeName: routeName, pageName: routeName, data: arguments);
      } else {
        args = ScreenArgsModel(routeName: routeName, pageName: routeName);
      }
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => DynamicScreen(args: args),
      ));
    }
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    // If route is not in map, it might be a dynamic route handled by navigateTo
    return null;
  }
}
