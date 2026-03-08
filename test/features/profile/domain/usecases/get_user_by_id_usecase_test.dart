import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/profile/domain/entities/profile_entity.dart';
import 'package:myevents/features/profile/domain/repositories/profile_repository.dart';
import 'package:myevents/features/profile/domain/usecases/get_user_by_id_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late GetUserByIdUsecase getUserByIdUsecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    getUserByIdUsecase = GetUserByIdUsecase(
      profileRepository: mockProfileRepository,
    );
  });

  group('GetUserByIdUsecase', () {
    test('should return user profile when userId is valid', () async {
      // Arrange
      const userId = 'user_123';
      final mockProfile = ProfileEntity(
        userId: userId,
        firstName: 'John',
        lastName: 'Doe',
        profilePicture: 'https://example.com/profile.jpg',
      );

      when(
        () => mockProfileRepository.getUserById(userId),
      ).thenAnswer((_) async => Right(mockProfile));

      // Act
      final result = await getUserByIdUsecase(
        GetUserByIdUsecaseParams(userId: userId),
      );

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => null), equals(mockProfile));
      verify(() => mockProfileRepository.getUserById(userId)).called(1);
    });

    test('should return failure when user is not found', () async {
      // Arrange
      const userId = 'invalid_user_id';

      when(
        () => mockProfileRepository.getUserById(userId),
      ).thenAnswer((_) async => Left(ApiFailure(message: 'User not found')));

      // Act
      final result = await getUserByIdUsecase(
        GetUserByIdUsecaseParams(userId: userId),
      );

      // Assert
      expect(result.isLeft(), true);
      expect(
        result.fold((failure) => failure.message, (_) => null),
        equals('User not found'),
      );
    });

    test('should call repository.getUserById with correct userId', () async {
      // Arrange
      const userId = 'user_456';
      final mockProfile = ProfileEntity(userId: userId);

      when(
        () => mockProfileRepository.getUserById(userId),
      ).thenAnswer((_) async => Right(mockProfile));

      // Act
      await getUserByIdUsecase(GetUserByIdUsecaseParams(userId: userId));

      // Assert
      verify(() => mockProfileRepository.getUserById(userId)).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });

    test('should return profile entity with all fields populated', () async {
      // Arrange
      const userId = 'user_789';
      final mockProfile = ProfileEntity(
        userId: userId,
        firstName: 'Jane',
        lastName: 'Smith',
        profilePicture: 'https://example.com/jane.jpg',
        password: 'hashedPassword',
      );

      when(
        () => mockProfileRepository.getUserById(userId),
      ).thenAnswer((_) async => Right(mockProfile));

      // Act
      final result = await getUserByIdUsecase(
        GetUserByIdUsecaseParams(userId: userId),
      );

      // Assert
      final profile = result.getOrElse(() => null);
      expect(profile?.userId, equals(userId));
      expect(profile?.firstName, equals('Jane'));
      expect(profile?.lastName, equals('Smith'));
      expect(profile?.profilePicture, equals('https://example.com/jane.jpg'));
    });

    test('should handle network error gracefully', () async {
      // Arrange
      const userId = 'user_error';

      when(
        () => mockProfileRepository.getUserById(userId),
      ).thenAnswer((_) async => Left(ApiFailure(message: 'Network error')));

      // Act
      final result = await getUserByIdUsecase(
        GetUserByIdUsecaseParams(userId: userId),
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, equals('Network error')),
        (_) => fail('Should return failure'),
      );
    });
  });
}
