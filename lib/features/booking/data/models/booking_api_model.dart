
import 'package:myevents/features/booking/domain/entities/booking_entity.dart';

class BookingApiModel {
final String? bookingId;
final String venueId;
final String banquetTitle;
final String eventDate;
final int guestCount;

BookingApiModel({
this.bookingId,
required this.venueId,
required this.banquetTitle,
required this.eventDate,
required this.guestCount,
});

Map<String, dynamic> toJson() {
return {
"venueId": venueId,
"eventDate": eventDate,
"guestCount": guestCount,
};
}

BookingEntity toEntity() {
return BookingEntity(
bookingId: bookingId,
banquetId: venueId,
banquetTitle: banquetTitle,
date: eventDate,
guests: guestCount,
);
}
}