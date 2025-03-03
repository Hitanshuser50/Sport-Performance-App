import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sportsmate/main.dart';
import 'package:sportsmate/providers/auth_provider.dart';
import 'package:sportsmate/providers/theme_provider.dart';
import 'package:sportsmate/screens/auth/login_screen.dart';
import 'package:sportsmate/utils/validators.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App should start with login screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  group('Validator Tests', () {
    test('Email Validation', () {
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail('invalid'), 'Please enter a valid email address');
      expect(Validators.validateEmail('test@example.com'), null);
    });

    test('Password Validation', () {
      expect(Validators.validatePassword(''), 'Password is required');
      expect(Validators.validatePassword('weak'), 'Password must be at least 6 characters');
      expect(Validators.validatePassword('weakpassword'), 'Password must contain at least one uppercase letter');
      expect(Validators.validatePassword('Weakpassword'), 'Password must contain at least one number');
      expect(Validators.validatePassword('WeakPassword1'), null);
    });

    test('Name Validation', () {
      expect(Validators.validateName(''), 'Name is required');
      expect(Validators.validateName('a'), 'Name must be at least 2 characters');
      expect(Validators.validateName('John'), null);
    });

    test('Number Validation', () {
      expect(Validators.validateNumber(''), 'This field is required');
      expect(Validators.validateNumber('abc'), 'Please enter a valid number');
      expect(Validators.validateNumber('123'), null);
      expect(Validators.validateNumber('-1', min: 0), 'Value must be greater than 0');
      expect(Validators.validateNumber('101', max: 100), 'Value must be less than 100');
    });
  });

  group('Theme Tests', () {
    testWidgets('Theme toggle should work', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: Builder(
            builder: (context) {
              final themeProvider = context.watch<ThemeProvider>();
              return MaterialApp(
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: themeProvider.themeMode,
                home: Scaffold(
                  body: Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initially light mode
      expect(
        (tester.widget(find.byType(Switch)) as Switch).value,
        false,
      );

      // Toggle to dark mode
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        (tester.widget(find.byType(Switch)) as Switch).value,
        true,
      );
    });
  });

  group('Auth Provider Tests', () {
    test('Initial state should be not loading', () {
      final authProvider = AuthProvider();
      expect(authProvider.isLoading, false);
    });

    test('Initial user should be null', () {
      final authProvider = AuthProvider();
      expect(authProvider.user, null);
    });
  });
}
