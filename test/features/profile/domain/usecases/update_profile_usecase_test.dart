import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/profile/domain/entities/profile_entity.dart';
import 'package:myevents/features/profile/domain/repositories/profile_repository.dart';
import 'package:myevents/features/profile/domain/usecases/update_profile_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  late UpdateProfileUsecase updateProfileUsecase;
  late MockProfileRepository mockProfileRepository;

  setUpAll(() {
    registerFallbackValue(FakeProfileEntity());
  });

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    updateProfileUsecase = UpdateProfileUsecase(
      profileRepository: mockProfileRepository,
    );
  });

  group('UpdateProfileUsecase', () {
    test('should update profile successfully with all fields', () async {
      // Arrange
      const params = UpdateProfileUsecaseParams(
        firstName: 'John',
        lastName: 'Doe',
        password: 'newPassword123',
      );

      when(
        () => mockProfileRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await updateProfileUsecase(params);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), isTrue);
      verify(() => mockProfileRepository.updateProfile(any())).called(1);
    });

    test('should update profile with only firstName', () async {
      // Arrange
      const params = UpdateProfileUsecaseParams(firstName: 'Jane');

      when(
        () => mockProfileRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await updateProfileUsecase(params);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), isTrue);
    });

    test('should return failure when update fails', () async {
      // Arrange
      const params = UpdateProfileUsecaseParams(
        firstName: 'Invalid',
        lastName: 'User',
      );

      when(
        () => mockProfileRepository.updateProfile(any()),
      ).thenAnswer((_) async => Left(ApiFailure(message: 'Update failed')));

      // Act
      final result = await updateProfileUsecase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, equals('Update failed')),
        (_) => fail('Should return failure'),
      );
    });

    test(
      'should call repository.updateProfile with correct parameters',
      () async {
        // Arrange
        const params = UpdateProfileUsecaseParams(
          firstName: 'TestUser',
          lastName: 'TestLast',
          password: 'testPass',
        );

        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await updateProfileUsecase(params);

        // Assert
        verify(() => mockProfileRepository.updateProfile(any())).called(1);
        verifyNoMoreInteractions(mockProfileRepository);
      },
    );

    test('should handle update with profile picture file', () async {
      // Arrange
      final mockFile = File('profile.jpg');
      final params = UpdateProfileUsecaseParams(
        firstName: 'John',
        lastName: 'Doe',
        profile: mockFile,
      );

      when(
        () => mockProfileRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await updateProfileUsecase(params);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), isTrue);
      verify(() => mockProfileRepository.updateProfile(any())).called(1);
    });
  });
}
