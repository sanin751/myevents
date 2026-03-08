import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/features/auth/domain/usecases/booking_usecase.dart';
import 'package:myevents/features/booking/domain/entities/booking_entity.dart';
import 'package:myevents/features/booking/domain/repositories/booking_repository.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

class FakeBookingEntity extends Fake implements BookingEntity {}

void main() {
  late BookingUsecase bookingUsecase;
  late MockBookingRepository mockBookingRepository;

  setUpAll(() {
    registerFallbackValue(FakeBookingEntity());
  });

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    bookingUsecase = BookingUsecase(bookingRepository: mockBookingRepository);
  });

  group('BookingUsecase', () {
    const testBookingParams = BookingParams(
      banquetId: 'banquet_123',
      banquetTitle: 'Grand Hotel Ballroom',
      date: '2026-03-15',
      guests: 150,
    );

    test('should return true when booking is created successfully', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await bookingUsecase(testBookingParams);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), true);
      verify(() => mockBookingRepository.createBooking(any())).called(1);
    });

    test('should call createBooking with correct BookingEntity', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      await bookingUsecase(testBookingParams);

      // Assert
      verify(
        () => mockBookingRepository.createBooking(
          any(
            that: isA<BookingEntity>()
                .having((e) => e.banquetId, 'banquetId', 'banquet_123')
                .having(
                  (e) => e.banquetTitle,
                  'banquetTitle',
                  'Grand Hotel Ballroom',
                )
                .having((e) => e.date, 'date', '2026-03-15')
                .having((e) => e.guests, 'guests', 150),
          ),
        ),
      ).called(1);
    });

    test('should return Failure when repository throws exception', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await bookingUsecase(testBookingParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle booking with different guest count', () async {
      // Arrange
      const smallGroupBooking = BookingParams(
        banquetId: 'banquet_456',
        banquetTitle: 'Intimate Dining Hall',
        date: '2026-04-20',
        guests: 20,
      );

      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await bookingUsecase(smallGroupBooking);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockBookingRepository.createBooking(
          any(that: isA<BookingEntity>().having((e) => e.guests, 'guests', 20)),
        ),
      ).called(1);
    });

    test('should handle booking with different date', () async {
      // Arrange
      const futureBooking = BookingParams(
        banquetId: 'banquet_789',
        banquetTitle: 'Future Event Venue',
        date: '2026-12-25',
        guests: 200,
      );

      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await bookingUsecase(futureBooking);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockBookingRepository.createBooking(
          any(
            that: isA<BookingEntity>().having(
              (e) => e.date,
              'date',
              '2026-12-25',
            ),
          ),
        ),
      ).called(1);
    });

    test('should return Failure on network error', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenThrow(Exception('Network error'));

      // Act
      final result = await bookingUsecase(testBookingParams);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should only call createBooking once', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      await bookingUsecase(testBookingParams);

      // Assert
      verifyNever(() => mockBookingRepository.getBookings());
      verify(() => mockBookingRepository.createBooking(any())).called(1);
    });

    test('should handle multiple sequential bookings', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      const booking1 = BookingParams(
        banquetId: 'banquet_001',
        banquetTitle: 'Venue 1',
        date: '2026-05-01',
        guests: 100,
      );

      const booking2 = BookingParams(
        banquetId: 'banquet_002',
        banquetTitle: 'Venue 2',
        date: '2026-05-02',
        guests: 200,
      );

      // Act
      final result1 = await bookingUsecase(booking1);
      final result2 = await bookingUsecase(booking2);

      // Assert
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
      verify(() => mockBookingRepository.createBooking(any())).called(2);
    });

    test('should preserve booking details in BookingEntity', () async {
      // Arrange
      const testParams = BookingParams(
        banquetId: 'test_venue_123',
        banquetTitle: 'Test Venue Title',
        date: '2026-06-15',
        guests: 75,
      );

      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      await bookingUsecase(testParams);

      // Assert - Verify all fields are preserved
      verify(
        () => mockBookingRepository.createBooking(
          any(
            that: isA<BookingEntity>()
                .having((e) => e.banquetId, 'banquetId', 'test_venue_123')
                .having(
                  (e) => e.banquetTitle,
                  'banquetTitle',
                  'Test Venue Title',
                )
                .having((e) => e.date, 'date', '2026-06-15')
                .having((e) => e.guests, 'guests', 75),
          ),
        ),
      ).called(1);
    });
  });
}
