import 'package:flutter/material.dart';
import 'package:myevents/screens/onboarding_screen1.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Plan your event with ease",
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
                  MaterialPageRoute(builder: (context) => OnboardingScreen1()),
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
