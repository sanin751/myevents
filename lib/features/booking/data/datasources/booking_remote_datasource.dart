import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/api/api_client.dart';
import 'package:myevents/core/services/storage/token_service.dart';
import '../models/booking_api_model.dart';

final bookingRemoteDatasourceProvider = Provider<BookingRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return BookingRemoteDatasource(apiClient, tokenService);
});

class BookingRemoteDatasource {
  final ApiClient apiClient;
  final TokenService _tokenService;

  BookingRemoteDatasource(this.apiClient, this._tokenService);

  /// CREATE BOOKING
  Future<void> createBooking(BookingApiModel booking) async {
    final token = await _tokenService.getToken();

    await apiClient.post(
      "/api/bookings",
      data: booking.toJson(),
      option: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// GET BOOKINGS
  Future<List<BookingApiModel>> getBookings() async {
    final token = await _tokenService.getToken();

    final response = await apiClient.get(
      "/api/bookings",
      option: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List data = response.data['data'] ?? [];

    return data.map((e) {
      final venue = e['venueId'];

      return BookingApiModel(
        bookingId: e['_id'] ?? "",
        venueId: venue['_id'] ?? "",
        banquetTitle: venue['title'] ?? "",
        eventDate: e['eventDate'] ?? "",
        guestCount: e['guestCount'] ?? 0,
      );
    }).toList();
  }
}
