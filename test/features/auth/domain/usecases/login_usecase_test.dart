import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/auth/domain/entities/auth_entity.dart';
import 'package:myevents/features/auth/domain/repositories/auth_repository.dart';
import 'package:myevents/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  group('LoginUsecase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testLoginParams = LoginParams(
      email: testEmail,
      password: testPassword,
    );

    final mockAuthEntity = AuthEntity(
      authId: 'auth_123',
      firstName: 'John',
      lastName: 'Doe',
      email: testEmail,
      password: testPassword,
      role: 'user',
    );

    test('should return AuthEntity on successful login', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => Right(mockAuthEntity));

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => mockAuthEntity), equals(mockAuthEntity));
      verify(() => mockAuthRepository.login(testEmail, testPassword)).called(1);
    });

    test('should return Failure on failed authentication', () async {
      // Arrange
      when(() => mockAuthRepository.login(testEmail, testPassword)).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Invalid credentials')),
      );

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should call login with correct email and password', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => Right(mockAuthEntity));

      // Act
      await loginUsecase(testLoginParams);

      // Assert
      verify(() => mockAuthRepository.login(testEmail, testPassword)).called(1);
    });

    test('should return AuthEntity with correct firstName', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => Right(mockAuthEntity));

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(
        result.fold((l) => null, (authEntity) => authEntity.firstName),
        'John',
      );
    });

    test('should return AuthEntity with correct lastName', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => Right(mockAuthEntity));

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(
        result.fold((l) => null, (authEntity) => authEntity.lastName),
        'Doe',
      );
    });

    test('should return AuthEntity with authId', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => Right(mockAuthEntity));

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(
        result.fold((l) => null, (authEntity) => authEntity.authId),
        'auth_123',
      );
    });

    test('should handle network error', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(testEmail, testPassword),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => loginUsecase(testLoginParams), throwsException);
    });

    test('should return Failure with invalid credentials', () async {
      // Arrange
      const invalidParams = LoginParams(
        email: 'invalid@example.com',
        password: 'wrongpassword',
      );

      when(
        () => mockAuthRepository.login('invalid@example.com', 'wrongpassword'),
      ).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Invalid credentials')),
      );

      // Act
      final result = await loginUsecase(invalidParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle multiple sequential logins', () async {
      // Arrange
      const loginParams1 = LoginParams(
        email: 'user1@example.com',
        password: 'pass1',
      );
      const loginParams2 = LoginParams(
        email: 'user2@example.com',
        password: 'pass2',
      );

      final authEntity1 = AuthEntity(
        authId: 'auth_1',
        firstName: 'User',
        lastName: 'One',
        email: 'user1@example.com',
        role: 'user',
      );

      final authEntity2 = AuthEntity(
        authId: 'auth_2',
        firstName: 'User',
        lastName: 'Two',
        email: 'user2@example.com',
        role: 'user',
      );

      when(
        () => mockAuthRepository.login('user1@example.com', 'pass1'),
      ).thenAnswer((_) async => Right(authEntity1));
      when(
        () => mockAuthRepository.login('user2@example.com', 'pass2'),
      ).thenAnswer((_) async => Right(authEntity2));

      // Act
      final result1 = await loginUsecase(loginParams1);
      final result2 = await loginUsecase(loginParams2);

      // Assert
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
      verify(
        () => mockAuthRepository.login('user1@example.com', 'pass1'),
      ).called(1);
      verify(
        () => mockAuthRepository.login('user2@example.com', 'pass2'),
      ).called(1);
    });

    test('should return AuthEntity with user role', () async {
      // Arrange
      final authEntityWithRole = AuthEntity(
        authId: 'auth_123',
        firstName: 'John',
        lastName: 'Doe',
        email: testEmail,
        role: 'user',
      );

      when(
        () => mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => Right(authEntityWithRole));

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(result.fold((l) => null, (authEntity) => authEntity.role), 'user');
    });

    test('should return Failure on server error', () async {
      // Arrange
      when(() => mockAuthRepository.login(testEmail, testPassword)).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Server error', statusCode: 500)),
      );

      // Act
      final result = await loginUsecase(testLoginParams);

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
