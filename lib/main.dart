import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/soccer_splash_screen.dart';
import 'package:scoreline/features/scores/presentation/screens/home_page.dart';
import 'package:scoreline/features/favourites/presentation/screens/favourite_screen.dart';
import 'package:scoreline/features/watch/presentation/screens/watch_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => SoccerSplashScreen(
            onComplete: () => context.go('/'),
          ),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(title: 'ScoreLine'),
        ),
        GoRoute(
          path: '/Favourites',
          builder: (context, state) => const Favourites(title: "Favourites"),
        ),
        GoRoute(
          path: '/Watch',
          builder: (context, state) => const Watch(title: "Watch"),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ScoreLine',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
      ),
      routerConfig: router,
    );
  }
}


//0762378600-