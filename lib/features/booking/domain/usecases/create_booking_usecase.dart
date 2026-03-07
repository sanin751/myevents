import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';

final createBookingUseCaseProvider =
    Provider<CreateBookingUseCase>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return CreateBookingUseCase(repo);
});

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<void> call(BookingEntity booking) async {
    await repository.createBooking(booking);
  }
}