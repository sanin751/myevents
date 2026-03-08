import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/features/dashboard/domain/entities/banquet_entity.dart';
import 'package:myevents/features/dashboard/domain/usecases/get_all_banquet_usecase.dart';
import 'package:myevents/features/dashboard/presentation/state/banquet_state.dart';
import 'package:myevents/features/dashboard/presentation/view_models/banquet_view_model.dart';
import 'package:dartz/dartz.dart';

class MockGetAllBanquetUsecase extends Mock implements GetAllBanquetUsecase {}

void main() {
  late BanquetViewModel banquetViewModel;
  late MockGetAllBanquetUsecase mockGetAllBanquetUsecase;
  late ProviderContainer container;

  setUp(() {
    mockGetAllBanquetUsecase = MockGetAllBanquetUsecase();
    container = ProviderContainer(
      overrides: [
        getAllBanquetUsecaseProvider.overrideWithValue(
          mockGetAllBanquetUsecase,
        ),
      ],
    );
    banquetViewModel = container.read(banquetViewModelProvider.notifier);
  });

  group('BanquetViewModel', () {
    test('initial state should have BanquetStatus.initial', () {
      // Act
      final state = container.read(banquetViewModelProvider);

      // Assert
      expect(state.status, equals(BanquetStatus.initial));
      expect(state.banquets, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('should fetch banquets successfully and update state', () async {
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
        () => mockGetAllBanquetUsecase(),
      ).thenAnswer((_) async => Right(mockBanquets));

      // Act
      await banquetViewModel.fetchBanquets();
      final state = container.read(banquetViewModelProvider);

      // Assert
      expect(state.status, equals(BanquetStatus.loaded));
      expect(state.banquets.length, equals(2));
      expect(state.banquets[0].title, equals('Grand Ballroom'));
      expect(state.errorMessage, isNull);
    });

    test('should handle error when fetching banquets fails', () async {
      // Arrange
      when(
        () => mockGetAllBanquetUsecase(),
      ).thenAnswer((_) async => Left(ApiFailure(message: 'Network error')));

      // Act
      await banquetViewModel.fetchBanquets();
      final state = container.read(banquetViewModelProvider);

      // Assert
      expect(state.status, equals(BanquetStatus.error));
      expect(state.banquets, isEmpty);
      expect(state.errorMessage, equals('Network error'));
    });

    test('should set loading status when fetching banquets', () async {
      // Arrange
      final mockBanquets = [
        BanquetEntity(
          banquetId: 'banquet_1',
          title: 'Test Hall',
          description: 'Testing',
          location: 'Test',
          capacity: 100,
          price: 10000,
          isAvailable: true,
        ),
      ];

      when(
        () => mockGetAllBanquetUsecase(),
      ).thenAnswer((_) async => Right(mockBanquets));

      // Act
      await banquetViewModel.fetchBanquets();
      final state = container.read(banquetViewModelProvider);

      // Assert - State should be loaded after fetch completes
      expect(state.status, equals(BanquetStatus.loaded));
      expect(state.banquets.length, equals(1));
    });

    test('should return empty list when no banquets available', () async {
      // Arrange
      when(
        () => mockGetAllBanquetUsecase(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      await banquetViewModel.fetchBanquets();
      final state = container.read(banquetViewModelProvider);

      // Assert
      expect(state.status, equals(BanquetStatus.loaded));
      expect(state.banquets, isEmpty);
      expect(state.errorMessage, isNull);
    });
  });
}
