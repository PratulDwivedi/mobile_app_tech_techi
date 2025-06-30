import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/main.dart';
import 'package:mobile_app_tech_techi/screens/login_screen.dart';

void main() {
  group('App Tests', () {
    testWidgets('App should start with login screen',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Verify that login screen is displayed
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('App should have proper theme configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Verify theme is applied
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
      expect(app.darkTheme, isNotNull);
    });

    testWidgets('App should handle navigation properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Verify initial route
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
