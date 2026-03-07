import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';

final getBookingsUseCaseProvider =
    Provider<GetBookingsUseCase>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return GetBookingsUseCase(repo);
});

class GetBookingsUseCase {

  final BookingRepository repository;

  GetBookingsUseCase(this.repository);

  Future<List<BookingEntity>> call() {
    return repository.getBookings();
  }
}