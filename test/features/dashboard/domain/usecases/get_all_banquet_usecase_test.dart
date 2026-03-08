import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/dashboard/data/repositories/banquet_repository.dart';
import 'package:myevents/features/dashboard/domain/entities/banquet_entity.dart';

import 'package:myevents/features/dashboard/domain/usecases/get_all_banquet_usecase.dart';

class MockBanquetRepository extends Mock implements IBanquetRepository {}

void main() {
  late GetAllBanquetUsecase getAllBanquetUsecase;
  late MockBanquetRepository mockBanquetRepository;

  setUp(() {
    mockBanquetRepository = MockBanquetRepository();
    getAllBanquetUsecase = GetAllBanquetUsecase(
      repository: mockBanquetRepository,
    );
  });

  group('GetAllBanquetUsecase', () {
    test('should return list of banquets on success', () async {
      // Arrange
      final mockBanquets = [
        BanquetEntity(
          banquetId: 'banquet_1',
          title: 'Grand Ballroom',
          description: 'Elegant wedding venue',
          location: 'Downtown',
          capacity: 500,
          price: 50000,
          isAvailable: true,
        ),
        BanquetEntity(
          banquetId: 'banquet_2',
          title: 'Crystal Hall',
          description: 'Corporate events hall',
          location: 'Midtown',
          capacity: 300,
          price: 35000,
          isAvailable: true,
        ),
      ];

      when(
        () => mockBanquetRepository.getAllBanquets(),
      ).thenAnswer((_) async => Right(mockBanquets));

      // Act
      final result = await getAllBanquetUsecase();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), equals(mockBanquets));
      expect(result.getOrElse(() => []).length, equals(2));
    });

    test('should return Failure on error', () async {
      // Arrange
      when(() => mockBanquetRepository.getAllBanquets()).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Failed to fetch banquets')),
      );

      // Act
      final result = await getAllBanquetUsecase();

      // Assert
      expect(result.isLeft(), true);
    });

    test('should return empty list when no banquets available', () async {
      // Arrange
      when(
        () => mockBanquetRepository.getAllBanquets(),
      ).thenAnswer((_) async => Right(const []));

      // Act
      final result = await getAllBanquetUsecase();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('should return banquets with correct data', () async {
      // Arrange
      final mockBanquets = [
        BanquetEntity(
          banquetId: 'banquet_123',
          title: 'Luxury Palace',
          description: 'Premium wedding venue',
          location: 'Elite District',
          capacity: 1000,
          price: 100000,
          isAvailable: true,
        ),
      ];

      when(
        () => mockBanquetRepository.getAllBanquets(),
      ).thenAnswer((_) async => Right(mockBanquets));

      // Act
      final result = await getAllBanquetUsecase();
      final banquets = result.getOrElse(() => []);

      // Assert
      expect(banquets[0].title, equals('Luxury Palace'));
      expect(banquets[0].capacity, equals(1000));
      expect(banquets[0].price, equals(100000));
      expect(banquets[0].isAvailable, isTrue);
    });

    test('should call repository exactly once', () async {
      // Arrange
      when(
        () => mockBanquetRepository.getAllBanquets(),
      ).thenAnswer((_) async => Right(const []));

      // Act
      await getAllBanquetUsecase();

      // Assert
      verify(() => mockBanquetRepository.getAllBanquets()).called(1);
      verifyNoMoreInteractions(mockBanquetRepository);
    });
  });
}
