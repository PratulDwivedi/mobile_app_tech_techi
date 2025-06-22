import 'package:flutter/material.dart';
import 'package:mobile_app_tech_techi/screens/chat_screen.dart';
import 'package:mobile_app_tech_techi/screens/dynamic_screen.dart';
import 'package:mobile_app_tech_techi/screens/home_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final Map<String, WidgetBuilder> _routes = {
    '/home': (context) => const HomeScreen(),
    'chat': (context) => const ChatScreen(),
    // Add other fixed routes here
  };

  static void navigateTo(String routeName, {Object? arguments}) {
    if (_routes.containsKey(routeName)) {
      navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
    } else {
      // Navigate to DynamicScreen if route not found in fixed routes
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => DynamicScreen(
          routeName: routeName,
        ),
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