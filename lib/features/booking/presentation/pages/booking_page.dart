import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/booking_view_model.dart';

class BookingPage extends ConsumerStatefulWidget {
  final String banquetId;

  const BookingPage({super.key, required this.banquetId});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController guestController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      dateController.text =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Banquet"),
        backgroundColor: const Color(0xFFD84315),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// EVENT DATE
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: "Event Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// GUEST COUNT
            TextField(
              controller: guestController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of Guests",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            /// BOOK BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  if (dateController.text.isEmpty ||
                      guestController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );

                    return;
                  }

                  ref
                      .read(bookingViewModelProvider.notifier)
                      .bookBanquet(
                        widget.banquetId,
                        dateController.text,
                        int.parse(guestController.text),
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking submitted successfully"),
                      backgroundColor: Color.fromARGB(255, 14, 161, 4),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
