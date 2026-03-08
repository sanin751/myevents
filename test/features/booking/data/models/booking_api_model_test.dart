import 'package:flutter_test/flutter_test.dart';
import 'package:myevents/features/booking/data/models/booking_api_model.dart';
import 'package:myevents/features/booking/domain/entities/booking_entity.dart';

void main() {
  group('BookingApiModel', () {
    const testVenueId = 'venue_123';
    const testBanquetTitle = 'Grand Ballroom';
    const testEventDate = '2026-03-15';
    const testGuestCount = 150;
    const testBookingId = 'booking_uuid_123';

    test('toJson should return correct JSON structure', () {
      // Arrange
      final bookingModel = BookingApiModel(
        venueId: testVenueId,
        banquetTitle: testBanquetTitle,
        eventDate: testEventDate,
        guestCount: testGuestCount,
      );

      // Act
      final json = bookingModel.toJson();

      // Assert
      expect(json['venueId'], equals(testVenueId));
      expect(json['eventDate'], equals(testEventDate));
      expect(json['guestCount'], equals(testGuestCount));
      expect(json.length, equals(3));
    });

    test('toEntity should convert to BookingEntity correctly', () {
      // Arrange
      final bookingModel = BookingApiModel(
        bookingId: testBookingId,
        venueId: testVenueId,
        banquetTitle: testBanquetTitle,
        eventDate: testEventDate,
        guestCount: testGuestCount,
      );

      // Act
      final bookingEntity = bookingModel.toEntity();

      // Assert
      expect(bookingEntity, isA<BookingEntity>());
      expect(bookingEntity.bookingId, equals(testBookingId));
      expect(bookingEntity.banquetId, equals(testVenueId));
      expect(bookingEntity.banquetTitle, equals(testBanquetTitle));
      expect(bookingEntity.date, equals(testEventDate));
      expect(bookingEntity.guests, equals(testGuestCount));
    });

    test('constructor should handle optional bookingId', () {
      // Act
      final bookingModel1 = BookingApiModel(
        venueId: testVenueId,
        banquetTitle: testBanquetTitle,
        eventDate: testEventDate,
        guestCount: testGuestCount,
      );

      final bookingModel2 = BookingApiModel(
        bookingId: testBookingId,
        venueId: testVenueId,
        banquetTitle: testBanquetTitle,
        eventDate: testEventDate,
        guestCount: testGuestCount,
      );

      // Assert
      expect(bookingModel1.bookingId, isNull);
      expect(bookingModel2.bookingId, equals(testBookingId));
    });

    test('toEntity should map venueId to banquetId', () {
      // Arrange
      const customVenueId = 'venue_456';
      final bookingModel = BookingApiModel(
        venueId: customVenueId,
        banquetTitle: testBanquetTitle,
        eventDate: testEventDate,
        guestCount: testGuestCount,
      );

      // Act
      final bookingEntity = bookingModel.toEntity();

      // Assert
      expect(bookingEntity.banquetId, equals(customVenueId));
    });

    test('toJson should not include bookingId', () {
      // Arrange
      final bookingModel = BookingApiModel(
        bookingId: testBookingId,
        venueId: testVenueId,
        banquetTitle: testBanquetTitle,
        eventDate: testEventDate,
        guestCount: testGuestCount,
      );

      // Act
      final json = bookingModel.toJson();

      // Assert
      expect(json.containsKey('bookingId'), isFalse);
      expect(json.containsKey('banquetTitle'), isFalse);
    });
  });
}
