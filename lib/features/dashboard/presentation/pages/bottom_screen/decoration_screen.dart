import 'package:flutter/material.dart';

class DecorationScreen extends StatelessWidget {
  const DecorationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Decoration'),
        backgroundColor: const Color(0xFFD84315),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            const Text(
              'Decoration Themes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// OFFER CARD
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 90,
                width: 180,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F61),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Decoration Special",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "15% OFF This Month",
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

            /// PACKAGES
            _packageCard(
              name: 'Wedding Package                      Rs.50000',
              height: 180,
              price:
                  'Includes Stage decoration - Gate decoration - Mandap - Name Board - Fireworks',
              image: 'assets/image/decoration.png',
            ),

            _packageCard(
              name: 'Birthday Package                      Rs.10000',
              height: 200,
              price: 'Includes Cake - Balloons - Decorations',
              image: 'assets/image/image.png',
            ),

            _packageCard(
              name: 'Outdoor Package                      Rs.30000',
              height: 200,
              price: 'Includes Galley decoration - Nameboard - Stage - Mandap',
              image: 'assets/image/out decoration.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageCard({
    required String name,
    required double height,
    required String price,
    required String image,
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(image, height: height, fit: BoxFit.cover),
          ),

          /// DETAILS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  ' $price',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 5, 0, 0),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
