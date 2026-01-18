
import 'package:flutter/material.dart';
import 'package:flutter_project/providers/auth_provider.dart';
import 'package:flutter_project/providers/language_provider.dart';
import 'package:flutter_project/screens/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../mocks.dart';

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockLanguageProvider mockLanguageProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockLanguageProvider = MockLanguageProvider();
  });

  Widget createLoginScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
        ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
      ],
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('Login screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    // Check for title
    expect(find.text('Employee Manager'), findsOneWidget);
    
    // Check for text fields
    expect(find.byType(TextField), findsNWidgets(2));
    
    // Check for button
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Show error when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginScreen());

    // Find login button and tap it
    final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginBtn); // Ensure it's visible (scroll if needed)
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // Should verify error message logic
    expect(find.text('Please enter both email and password'), findsOneWidget);
  });
}
