import 'package:flutter/material.dart';

import 'package:myevents/screens/splash_screen.dart';
import 'package:myevents/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: getApplicationTheme(),
    );
  }
}
