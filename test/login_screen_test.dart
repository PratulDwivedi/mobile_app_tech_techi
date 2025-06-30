import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_tech_techi/screens/login_screen.dart';

void main() {
  group('Login Screen Tests', () {
    testWidgets('Login screen should display all required elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify login form elements are present
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField),
          findsNWidgets(2)); // Email and password fields
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Login screen should validate email format',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Find email field and enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      // Trigger validation by tapping login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Login screen should validate password length',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Find password field and enter short password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '123');
      await tester.pump();

      // Trigger validation by tapping login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation error
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('Login screen should show loading state during login',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
