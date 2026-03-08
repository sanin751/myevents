import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/core/error/failures.dart';
import 'package:myevents/core/usecases/app_usecases.dart';
import 'package:myevents/features/booking/domain/entities/booking_entity.dart';
import 'package:myevents/features/booking/domain/repositories/booking_repository.dart';
import 'package:myevents/features/booking/data/repositories/booking_repository_impl.dart';

class BookingParams extends Equatable {
  final String banquetId;
  final String banquetTitle;
  final String date;
  final int guests;

  const BookingParams({
    required this.banquetId,
    required this.banquetTitle,
    required this.date,
    required this.guests,
  });

  @override
  List<Object?> get props => [banquetId, banquetTitle, date, guests];
}

// Create Provider
final bookingUsecaseProvider = Provider<BookingUsecase>((ref) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return BookingUsecase(bookingRepository: bookingRepository);
});

class BookingUsecase implements UsecaseWithParms<bool, BookingParams> {
  final BookingRepository _bookingRepository;

  BookingUsecase({required BookingRepository bookingRepository})
      : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, bool>> call(BookingParams params) async {
    try {
      final booking = BookingEntity(
        banquetId: params.banquetId,
        banquetTitle: params.banquetTitle,
        date: params.date,
        guests: params.guests,
      );
      await _bookingRepository.createBooking(booking);
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: 'Booking creation failed'));
    }
  }
}
