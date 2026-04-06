import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/player_screen.dart';
import 'screens/search_screen.dart';

class LanaZApp extends StatelessWidget {
  const LanaZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lana Z',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.player: (_) => const PlayerScreen(),
        AppRoutes.search: (_) => const SearchScreen(),
      },
    );
  }
}
