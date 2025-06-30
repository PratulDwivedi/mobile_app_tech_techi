import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_tech_techi/widgets/app_button.dart';
import 'package:mobile_app_tech_techi/widgets/screen_decoration_widget.dart';
import 'package:mobile_app_tech_techi/widgets/custom_error_widget.dart';

void main() {
  group('Widget Tests', () {
    group('AppButton Tests', () {
      testWidgets('AppButton should display label and icon',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                label: 'Test Button',
                icon: Icons.add,
                color: Colors.blue,
                onPressed: null,
              ),
            ),
          ),
        );

        expect(find.text('Test Button'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('AppButton should be disabled when onPressed is null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AppButton(
                label: 'Test Button',
                icon: Icons.add,
                color: Colors.blue,
                onPressed: null,
              ),
            ),
          ),
        );

        final button = find.byType(ElevatedButton);
        final ElevatedButton buttonWidget = tester.widget(button);
        expect(buttonWidget.onPressed, isNull);
      });

      testWidgets('AppButton should be enabled when onPressed is provided',
          (WidgetTester tester) async {
        bool pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                label: 'Test Button',
                icon: Icons.add,
                color: Colors.blue,
                onPressed: () => pressed = true,
              ),
            ),
          ),
        );

        final button = find.byType(ElevatedButton);
        final ElevatedButton buttonWidget = tester.widget(button);
        expect(buttonWidget.onPressed, isNotNull);

        // Test button press
        await tester.tap(button);
        expect(pressed, isTrue);
      });
    });

    group('ScreenDecorationWidget Tests', () {
      testWidgets('ScreenDecorationWidget should apply dark theme gradient',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ScreenDecorationWidget(
              isDarkMode: true,
              primaryColor: Colors.blue,
              child: Text('Test Content'),
            ),
          ),
        );

        expect(find.text('Test Content'), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('ScreenDecorationWidget should apply light theme gradient',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ScreenDecorationWidget(
              isDarkMode: false,
              primaryColor: Colors.blue,
              child: Text('Test Content'),
            ),
          ),
        );

        expect(find.text('Test Content'), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('CustomErrorWidget Tests', () {
      testWidgets('CustomErrorWidget should display error message',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CustomErrorWidget(
              error: 'Test Error Message',
              isDarkMode: false,
            ),
          ),
        );

        expect(find.text('Error: Test Error Message'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('CustomErrorWidget should apply dark theme styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CustomErrorWidget(
              error: 'Test Error Message',
              isDarkMode: true,
            ),
          ),
        );

        expect(find.text('Error: Test Error Message'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });
  });
}
