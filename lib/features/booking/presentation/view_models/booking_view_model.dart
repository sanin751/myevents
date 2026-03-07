import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/features/booking/domain/usecases/get_booking_usecase.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';


class BookingState {
  final bool loading;
  final List<BookingEntity> bookings;

  BookingState({
    required this.loading,
    required this.bookings,
  });

  BookingState.initial()
      : loading = false,
        bookings = [];
}

final bookingViewModelProvider =
    NotifierProvider<BookingViewModel, BookingState>(
        BookingViewModel.new);

class BookingViewModel extends Notifier<BookingState> {

  late CreateBookingUseCase createBookingUseCase;
  late GetBookingsUseCase getBookingsUseCase;

  @override
  BookingState build() {
    createBookingUseCase = ref.read(createBookingUseCaseProvider);
    getBookingsUseCase = ref.read(getBookingsUseCaseProvider);

    return BookingState.initial();
  }

  Future<void> fetchBookings() async {

    state = BookingState(loading: true, bookings: []);

    final result = await getBookingsUseCase();

    state = BookingState(
      loading: false,
      bookings: result,
    );
  }

  Future<void> bookBanquet(
      String banquetId, String date, int guests) async {

    await createBookingUseCase(
      BookingEntity(
        banquetId: banquetId,
        date: date,
        guests: guests,
      ),
    );

    fetchBookings();
  }
}