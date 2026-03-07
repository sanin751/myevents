import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/features/dashboard/presentation/view_models/banquet_view_model.dart';
import 'package:myevents/features/booking/presentation/pages/booking_page.dart';

class BanquetScreen extends ConsumerStatefulWidget {
  const BanquetScreen({super.key});

  @override
  ConsumerState<BanquetScreen> createState() => _BanquetScreenState();
}

class _BanquetScreenState extends ConsumerState<BanquetScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetch banquet data
    Future.microtask(
      () => ref.read(banquetViewModelProvider.notifier).fetchBanquets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final banquetState = ref.watch(banquetViewModelProvider);
    final banquets = banquetState.banquets;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('Banquet'),
        backgroundColor: const Color(0xFFD84315),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// SPECIAL OFFER BOX
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 90,
                width: 180,
                padding: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F61),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Banquet Special",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "20% OFF This Week",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// HEADER
            const Text(
              'Our Banquet Halls',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// BANQUET LIST
            Column(
              children: banquets.map((banquet) {
                return _banquetCard(
                  banquetId: banquet.banquetId ?? "",
                  title: banquet.title,
                  image: banquet.image,
                  height: 200,
                  price: banquet.price,
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// BANQUET CARD
  Widget _banquetCard({
    required String banquetId,
    required String title,
    required String? image,
    required double height,
    required double price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(247, 246, 247, 1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),

            child: image != null && image.isNotEmpty
                ? Image.network(
                    "http://10.0.2.2:5050/uploads/$image",
                    height: height,
                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: height,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                        ),
                      );
                    },
                  )

                : Container(
                    height: height,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  ),
          ),

          /// TEXT SECTION
          Padding(
            padding: const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                /// PRICE
                Text(
                  "Starting at Rs. ${price.toStringAsFixed(0)} per person",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                /// BUTTONS
                Row(
                  children: [

                    /// VIEW BUTTON
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          /// optional details page
                        },
                        child: const Text('View'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// BOOK BUTTON
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                          /// OPEN BOOKING PAGE
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingPage(
                                banquetId: banquetId,
                              ),
                            ),
                          );
                        },
                        child: const Text('Book'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}