import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/screens/dynamic_screen.dart';
import 'package:mobile_app_tech_techi/models/screen_args_model.dart';

void main() {
  group('Dynamic Screen Tests', () {
    testWidgets('Dynamic screen should display loading state initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DynamicScreen(
              args: ScreenArgsModel(
                routeName: '/test',
                pageName: 'Test Page',
                data: {},
                isHome: false,
              ),
            ),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Dynamic screen should display app bar with title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DynamicScreen(
              args: ScreenArgsModel(
                routeName: '/test',
                pageName: 'Test Page',
                data: {},
                isHome: false,
              ),
            ),
          ),
        ),
      );

      // Should show app bar with title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Test Page'), findsOneWidget);
    });

    testWidgets('Dynamic screen should show search button when isHome is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DynamicScreen(
              args: ScreenArgsModel(
                routeName: '/test',
                pageName: 'Test Page',
                data: {},
                isHome: true,
              ),
            ),
          ),
        ),
      );

      // Should show search button in app bar
      expect(find.byIcon(Icons.pageview_sharp), findsOneWidget);
    });

    testWidgets(
        'Dynamic screen should not show search button when isHome is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DynamicScreen(
              args: ScreenArgsModel(
                routeName: '/test',
                pageName: 'Test Page',
                data: {},
                isHome: false,
              ),
            ),
          ),
        ),
      );

      // Should not show search button in app bar
      expect(find.byIcon(Icons.pageview_sharp), findsNothing);
    });

    testWidgets('Dynamic screen should show drawer when isHome is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DynamicScreen(
              args: ScreenArgsModel(
                routeName: '/test',
                pageName: 'Test Page',
                data: {},
                isHome: true,
              ),
            ),
          ),
        ),
      );

      // Should show drawer
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('Dynamic screen should not show drawer when isHome is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DynamicScreen(
              args: ScreenArgsModel(
                routeName: '/test',
                pageName: 'Test Page',
                data: {},
                isHome: false,
              ),
            ),
          ),
        ),
      );

      // Should not show drawer
      expect(find.byType(Drawer), findsNothing);
    });
  });
}
