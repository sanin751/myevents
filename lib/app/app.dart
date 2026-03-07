import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/app/theme/theme_data.dart' as AppTheme;
import 'package:myevents/features/auth/presentation/pages/splash_screen.dart';
import 'package:myevents/navigator_key.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(AppTheme.themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      navigatorKey: appNavigatorKey,

      home: const SplashScreen(),

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
