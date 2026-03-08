import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/booking_remote_datasource.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_api_model.dart';

final bookingRepositoryProvider =
Provider<BookingRepository>((ref) {
final datasource = ref.read(bookingRemoteDatasourceProvider);
return BookingRepositoryImpl(datasource);
});

class BookingRepositoryImpl implements BookingRepository {
final BookingRemoteDatasource datasource;

BookingRepositoryImpl(this.datasource);

@override
Future<void> createBooking(BookingEntity booking) async {
final model = BookingApiModel(
venueId: booking.banquetId!,
banquetTitle: "",
eventDate: booking.date!,
guestCount: booking.guests!,
);

await datasource.createBooking(model);

}

@override
Future<List<BookingEntity>> getBookings() async {
final result = await datasource.getBookings();

return result.map((e) => e.toEntity()).toList();

}
}