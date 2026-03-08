import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myevents/features/booking/domain/entities/booking_entity.dart';
import 'package:myevents/features/booking/domain/repositories/booking_repository.dart';
import 'package:myevents/features/booking/domain/usecases/create_booking_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

class FakeBookingEntity extends Fake implements BookingEntity {}

void main() {
  late CreateBookingUseCase createBookingUseCase;
  late MockBookingRepository mockBookingRepository;

  setUpAll(() {
    registerFallbackValue(FakeBookingEntity());
  });

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    createBookingUseCase = CreateBookingUseCase(mockBookingRepository);
  });

  group('CreateBookingUseCase', () {
    final testBooking = BookingEntity(
      bookingId: 'booking_123',
      banquetId: 'banquet_456',
      banquetTitle: 'Grand Ballroom',
      date: '2026-03-15',
      guests: 150,
    );

    test(
      'should call repository.createBooking with correct booking entity',
      () async {
        // Arrange
        when(
          () => mockBookingRepository.createBooking(any()),
        ).thenAnswer((_) async => Future.value());

        // Act
        await createBookingUseCase(testBooking);

        // Assert
        verify(
          () => mockBookingRepository.createBooking(testBooking),
        ).called(1);
      },
    );

    test('should create booking with all required fields', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      await createBookingUseCase(testBooking);

      // Assert
      verify(
        () => mockBookingRepository.createBooking(
          any(
            that: isA<BookingEntity>()
                .having((e) => e.banquetId, 'banquetId', 'banquet_456')
                .having((e) => e.guests, 'guests', 150)
                .having((e) => e.date, 'date', '2026-03-15'),
          ),
        ),
      ).called(1);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => createBookingUseCase(testBooking), throwsException);
    });

    test('should handle booking with different guest counts', () async {
      // Arrange
      final smallBooking = BookingEntity(
        banquetId: 'venue_789',
        banquetTitle: 'Small Room',
        date: '2026-04-20',
        guests: 30,
      );

      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      await createBookingUseCase(smallBooking);

      // Assert
      verify(
        () => mockBookingRepository.createBooking(
          any(that: isA<BookingEntity>().having((e) => e.guests, 'guests', 30)),
        ),
      ).called(1);
    });

    test('should successfully create multiple bookings sequentially', () async {
      // Arrange
      final booking1 = BookingEntity(
        banquetId: 'venue_1',
        banquetTitle: 'Hall 1',
        date: '2026-05-01',
        guests: 100,
      );

      final booking2 = BookingEntity(
        banquetId: 'venue_2',
        banquetTitle: 'Hall 2',
        date: '2026-05-02',
        guests: 200,
      );

      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      await createBookingUseCase(booking1);
      await createBookingUseCase(booking2);

      // Assert
      verify(() => mockBookingRepository.createBooking(any())).called(2);
    });
  });
}
