import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase/notification_service.dart';
import 'models/screen_args_model.dart';
import 'providers/riverpod/data_providers.dart';
import 'screens/login_screen.dart';
import 'screens/dynamic_screen.dart';

class AuthWrapper extends ConsumerWidget {
  final NotificationServices notificationServices;
  const AuthWrapper({super.key, required this.notificationServices});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (authState) {
        final session = authState.session;
        if (session != null) {
          // Set up FCM in-app notification handling
          notificationServices.firebaseInit(context);
          // Use a default route or fetch from user profile if needed
          return DynamicScreen(
              args: ScreenArgsModel(
                  routeName: 'dashboard', pageName: 'dashboard', isHome: true));
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: Text('Loading...'),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
