import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/auth/domain/entities/auth_entity.dart';
import 'package:myevents/features/auth/domain/usecases/login_usecase.dart';
import 'package:myevents/features/auth/domain/usecases/register_usecase.dart';
import 'package:myevents/features/auth/presentation/state/auth_state.dart';
import 'package:myevents/features/auth/presentation/view_models/auth_viewmodel.dart';
import 'package:dartz/dartz.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeRegisterParams extends Fake implements RegisterParams {}

void main() {
  group('AuthViewModel', () {
    late MockLoginUsecase mockLoginUsecase;
    late MockRegisterUsecase mockRegisterUsecase;
    late ProviderContainer container;

    setUpAll(() {
      registerFallbackValue(FakeLoginParams());
      registerFallbackValue(FakeRegisterParams());
    });

    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      mockRegisterUsecase = MockRegisterUsecase();

      container = ProviderContainer(
        overrides: [
          loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
          registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        ],
      );
    });

    test('initial state should be AuthStatus.initial', () {
      // Act
      final authState = container.read(authViewModelProvider);

      // Assert
      expect(authState.status, equals(AuthStatus.initial));
      expect(authState.user, isNull);
      expect(authState.errorMessage, isNull);
    });

    test(
      'login should set status to authenticated with user on success',
      () async {
        // Arrange
        const testEmail = 'test@example.com';
        const testPassword = 'password123';

        final mockAuthEntity = AuthEntity(
          authId: 'auth_123',
          firstName: 'John',
          lastName: 'Doe',
          email: testEmail,
          role: 'user',
        );

        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => Right(mockAuthEntity));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.login(email: testEmail, password: testPassword);

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, equals(AuthStatus.authenticated));
        expect(state.user, equals(mockAuthEntity));
        expect(state.errorMessage, isNull);
      },
    );

    test('login should set error status and message on failure', () async {
      // Arrange
      const testEmail = 'test@example.com';
      const testPassword = 'wrongpassword';

      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Invalid credentials')),
      );

      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.login(email: testEmail, password: testPassword);

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, equals(AuthStatus.error));
      expect(state.errorMessage, equals('Invalid credentials'));
      expect(state.user, isNull);
    });

    test('register should set status to registered on success', () async {
      // Arrange
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Right(true));

      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.register(
        firstName: 'John',
        lastName: 'Doe',
        password: 'password123',
        email: 'john@example.com',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, equals(AuthStatus.registered));
      expect(state.errorMessage, isNull);
    });

    test('register should set error status and message on failure', () async {
      // Arrange
      when(() => mockRegisterUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Email already exists')),
      );

      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.register(
        firstName: 'Jane',
        lastName: 'Smith',
        password: 'password123',
        email: 'jane@example.com',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, equals(AuthStatus.error));
      expect(state.errorMessage, equals('Email already exists'));
    });
  });
}
