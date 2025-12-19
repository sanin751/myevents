import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {"title": "Banquet", "image": "assets/image/banquet.jpeg"},
      {"title": "Decoration", "image": "assets/image/decoration.png"},
      {"title": "Photography/Videography", "image": "assets/image/photo.png"},
      {"title": "Catering", "image": "assets/image/catering.png"},
      {"title": "Music & DJ", "image": "assets/image/music.png"},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Our Services",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 16),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ServiceIcon(icon: Icons.apartment, label: "Banquet"),
              _ServiceIcon(icon: Icons.celebration, label: "Decoration"),
              _ServiceIcon(icon: Icons.music_note, label: "Music & DJ"),
              _ServiceIcon(icon: Icons.camera, label: "Photography"),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Special Offer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

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
                    "5% OFF",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "On Your First Booking",
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

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceCard(
                image: service["image"] as String,
                title: service["title"] as String,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String image;
  final String title;

  const _ServiceCard({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 182, 236, 162),
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
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Color.fromARGB(245, 247, 187, 102),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 8, 8, 8),
            size: 26,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
