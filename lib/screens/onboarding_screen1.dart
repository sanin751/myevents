import 'package:flutter/material.dart';
import 'package:myevents/screens/onboarding_screen2.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Discover Event Services in One Place",
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingScreen2()),
                );
              },
              child: Text("Continue", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
