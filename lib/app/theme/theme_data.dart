import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================= LIGHT THEME =================
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color.fromARGB(255, 247, 248, 191),

  fontFamily: "Bricolage",

  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 18),
    displayMedium: TextStyle(fontSize: 18),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFE64A19),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color.fromARGB(245, 247, 187, 102),
    unselectedItemColor: Color.fromARGB(255, 110, 110, 110),
    selectedIconTheme: IconThemeData(size: 30),
    selectedLabelStyle: TextStyle(fontSize: 18),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFAE37),
      foregroundColor: Colors.white,
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFAE37)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFAE37), width: 2),
    ),
  ),
);


/// ================= DARK THEME =================
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF121212),

  fontFamily: "Bricolage",

  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 18),
    displayMedium: TextStyle(fontSize: 18),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Color(0xFFFFAE37),
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(size: 30),
    selectedLabelStyle: TextStyle(fontSize: 18),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFAE37),
      foregroundColor: Colors.black,
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFAE37)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFAE37), width: 2),
    ),
  ),
);


/// ================= THEME PROVIDER =================
class ThemeNotifier extends Notifier<ThemeMode> {

  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  /// Toggle between light and dark
  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Set DARK theme
  void setDark() {
    state = ThemeMode.dark;
  }

  /// Set LIGHT theme
  void setLight() {
    state = ThemeMode.light;
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);