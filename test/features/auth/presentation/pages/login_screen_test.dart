import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myevents/features/auth/presentation/pages/login_screen.dart';
import 'package:myevents/features/auth/presentation/state/auth_state.dart';
import 'package:myevents/features/auth/presentation/view_models/auth_viewmodel.dart';

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial);
  }
}

void main() {
  testWidgets("Should have logo", (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    await tester.pumpAndSettle();

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final Image imageWidget = tester.widget<Image>(imageFinder);
    final AssetImage assetImage = imageWidget.image as AssetImage;

    expect(assetImage.assetName, "assets/image/logo.png");
  });

  testWidgets("Should have login button", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewModelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    Finder loginButton = find.widgetWithText(ElevatedButton, "Log In");

    expect(loginButton, findsOneWidget);
  });
    testWidgets("Should have input field", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder emailField = find.byType(TextField).at(0);
    Finder passwordField = find.byType(TextField).at(1);

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
  });
}
