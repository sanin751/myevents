import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/auth/domain/entities/auth_entity.dart';
import 'package:myevents/features/auth/domain/repositories/auth_repository.dart';
import 'package:myevents/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late RegisterUsecase registerUsecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUsecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  group('RegisterUsecase', () {
    const testRegisterParams = RegisterParams(
      firstName: 'John',
      lastName: 'Doe',
      password: 'password123',
      email: 'john@example.com',
    );

    test('should return true on successful registration', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await registerUsecase(testRegisterParams);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), true);
      verify(() => mockAuthRepository.register(any())).called(1);
    });

    test('should create AuthEntity with correct firstName', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(testRegisterParams);

      // Assert
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>().having(
              (e) => e.firstName,
              'firstName',
              'John',
            ),
          ),
        ),
      ).called(1);
    });

    test('should create AuthEntity with correct lastName', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(testRegisterParams);

      // Assert
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>().having(
              (e) => e.lastName,
              'lastName',
              'Doe',
            ),
          ),
        ),
      ).called(1);
    });

    test('should create AuthEntity with correct email', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(testRegisterParams);

      // Assert
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>().having(
              (e) => e.email,
              'email',
              'john@example.com',
            ),
          ),
        ),
      ).called(1);
    });

    test('should create AuthEntity with correct password', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(testRegisterParams);

      // Assert
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>().having(
              (e) => e.password,
              'password',
              'password123',
            ),
          ),
        ),
      ).called(1);
    });

    test('should return Failure on registration failure', () async {
      // Arrange
      when(() => mockAuthRepository.register(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Registration failed')),
      );

      // Act
      final result = await registerUsecase(testRegisterParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should return Failure on network error', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => registerUsecase(testRegisterParams), throwsException);
    });

    test('should handle registration with optional email', () async {
      // Arrange
      const registerWithoutEmail = RegisterParams(
        firstName: 'Jane',
        lastName: 'Smith',
        password: 'securepass',
      );

      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await registerUsecase(registerWithoutEmail);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>()
                .having((e) => e.firstName, 'firstName', 'Jane')
                .having((e) => e.lastName, 'lastName', 'Smith'),
          ),
        ),
      ).called(1);
    });

    test('should handle registration with different email', () async {
      // Arrange
      const registerParams = RegisterParams(
        firstName: 'Alice',
        lastName: 'Johnson',
        password: 'mypassword',
        email: 'alice@example.com',
      );

      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await registerUsecase(registerParams);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>().having(
              (e) => e.email,
              'email',
              'alice@example.com',
            ),
          ),
        ),
      ).called(1);
    });

    test('should return Failure on duplicate email', () async {
      // Arrange
      when(() => mockAuthRepository.register(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Email already exists')),
      );

      // Act
      final result = await registerUsecase(testRegisterParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle multiple sequential registrations', () async {
      // Arrange
      const registerParams1 = RegisterParams(
        firstName: 'User1',
        lastName: 'One',
        password: 'pass1',
        email: 'user1@example.com',
      );

      const registerParams2 = RegisterParams(
        firstName: 'User2',
        lastName: 'Two',
        password: 'pass2',
        email: 'user2@example.com',
      );

      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result1 = await registerUsecase(registerParams1);
      final result2 = await registerUsecase(registerParams2);

      // Assert
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
      verify(() => mockAuthRepository.register(any())).called(2);
    });

    test('should preserve all registration parameters', () async {
      // Arrange
      const registerParams = RegisterParams(
        firstName: 'TestFirst',
        lastName: 'TestLast',
        password: 'testpass123',
        email: 'test@example.com',
      );

      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(registerParams);

      // Assert
      verify(
        () => mockAuthRepository.register(
          any(
            that: isA<AuthEntity>()
                .having((e) => e.firstName, 'firstName', 'TestFirst')
                .having((e) => e.lastName, 'lastName', 'TestLast')
                .having((e) => e.password, 'password', 'testpass123')
                .having((e) => e.email, 'email', 'test@example.com'),
          ),
        ),
      ).called(1);
    });

    test('should set default role as user', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(testRegisterParams);

      // Assert
      verify(
        () => mockAuthRepository.register(
          any(that: isA<AuthEntity>().having((e) => e.role, 'role', 'user')),
        ),
      ).called(1);
    });

    test('should return Failure on server error', () async {
      // Arrange
      when(() => mockAuthRepository.register(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Server error', statusCode: 500)),
      );

      // Act
      final result = await registerUsecase(testRegisterParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should only call register once per usecase call', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await registerUsecase(testRegisterParams);

      // Assert
      verify(() => mockAuthRepository.register(any())).called(1);
    });
  });
}
