import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myevents/features/auth/presentation/pages/signup_screen.dart';

void main() {
  testWidgets("Should have Input fields", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: const MaterialApp(home: SignupScreen())),
    );

    await tester.pumpAndSettle();

    Finder firstNameField = find.byType(TextField).at(0);
    Finder lastNameField = find.byType(TextField).at(1);
    Finder emailField = find.byType(TextField).at(2);
    Finder passwordField = find.byType(TextField).at(3);

    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
  });

  testWidgets("Should have SignUp button", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(child: const MaterialApp(home: SignupScreen())),
    );

    await tester.pumpAndSettle();

    Finder signUpButton = find.widgetWithText(ElevatedButton, 'Create Account');

    expect(signUpButton, findsOneWidget);
  });
}
