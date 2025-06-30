import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/app_config.dart';
import 'firebase/firebase_options.dart';
import 'firebase/notification_service.dart';
import 'models/screen_args_model.dart';
import 'providers/riverpod/theme_provider.dart';
import 'providers/riverpod/data_providers.dart';
import 'screens/login_screen.dart';
import 'screens/dynamic_screen.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (appConfig.serviceType == ServiceType.supabase) {
    // Initialize Supabase
    await Supabase.initialize(
      url: appConfig.apiBaseUrl,
      anonKey: appConfig.localKey,
    );
  }
  // Request notification permissions and set up FCM
  final notificationServices = NotificationServices();
  notificationServices.requestNotificationPermission();
  notificationServices.isTokenRefresh();

  runApp(
    ProviderScope(
      child: MyApp(notificationServices: notificationServices),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final NotificationServices notificationServices;
  const MyApp({super.key, required this.notificationServices});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.isDarkMode;
    final primaryColor = ref.watch(primaryColorProvider);

    return MaterialApp(
      title: 'Tech Techi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: NavigationService.onGenerateRoute,
      home: AuthWrapper(notificationServices: notificationServices),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
