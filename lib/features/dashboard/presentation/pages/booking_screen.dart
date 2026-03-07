import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/features/booking/presentation/view_models/booking_view_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(bookingViewModelProvider.notifier).fetchBookings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingViewModelProvider);

    return Scaffold(
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
              itemCount: state.bookings.length,

              itemBuilder: (context, index) {
                final booking = state.bookings[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text("Banquet ID: ${booking.banquetId}"),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${booking.date}"),
                        Text("Guests: ${booking.guests}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
