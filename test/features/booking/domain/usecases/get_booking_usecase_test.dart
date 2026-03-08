import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/features/booking/domain/entities/booking_entity.dart';
import 'package:myevents/features/booking/domain/repositories/booking_repository.dart';
import 'package:myevents/features/booking/domain/usecases/get_booking_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetBookingsUseCase getBookingsUseCase;
  late MockBookingRepository mockBookingRepository;

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    getBookingsUseCase = GetBookingsUseCase(mockBookingRepository);
  });

  group('GetBookingsUseCase', () {
    test('should return list of bookings from repository', () async {
      // Arrange
      final mockBookings = [
        BookingEntity(
          bookingId: 'booking_1',
          banquetId: 'venue_1',
          banquetTitle: 'Hall A',
          date: '2026-03-15',
          guests: 100,
        ),
        BookingEntity(
          bookingId: 'booking_2',
          banquetId: 'venue_2',
          banquetTitle: 'Hall B',
          date: '2026-03-20',
          guests: 200,
        ),
      ];

      when(
        () => mockBookingRepository.getBookings(),
      ).thenAnswer((_) async => mockBookings);

      // Act
      final result = await getBookingsUseCase();

      // Assert
      expect(result, equals(mockBookings));
      expect(result.length, equals(2));
      verify(() => mockBookingRepository.getBookings()).called(1);
    });

    test('should return empty list when no bookings exist', () async {
      // Arrange
      when(
        () => mockBookingRepository.getBookings(),
      ).thenAnswer((_) async => []);

      // Act
      final result = await getBookingsUseCase();

      // Assert
      expect(result, isEmpty);
      expect(result, equals([]));
    });

    test('should return bookings with correct data', () async {
      // Arrange
      final mockBookings = [
        BookingEntity(
          bookingId: 'booking_123',
          banquetId: 'venue_456',
          banquetTitle: 'Grand Ballroom',
          date: '2026-04-10',
          guests: 250,
        ),
      ];

      when(
        () => mockBookingRepository.getBookings(),
      ).thenAnswer((_) async => mockBookings);

      // Act
      final result = await getBookingsUseCase();

      // Assert
      expect(result[0].bookingId, equals('booking_123'));
      expect(result[0].guests, equals(250));
      expect(result[0].date, equals('2026-04-10'));
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(
        () => mockBookingRepository.getBookings(),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => getBookingsUseCase(), throwsException);
    });

    test('should call repository.getBookings exactly once', () async {
      // Arrange
      when(
        () => mockBookingRepository.getBookings(),
      ).thenAnswer((_) async => []);

      // Act
      await getBookingsUseCase();

      // Assert
      verify(() => mockBookingRepository.getBookings()).called(1);
      verifyNoMoreInteractions(mockBookingRepository);
    });
  });
}
