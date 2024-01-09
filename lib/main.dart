import 'package:cinelyric/screens/provider/movie_provider.dart';
import 'package:cinelyric/screens/provider/music_provider.dart';
import 'package:provider/provider.dart';
import 'elements/app_theme.dart';
import 'screens/funfact.dart';
import 'screens/home_page.dart';
import 'screens/landing_page.dart';
import 'account/user_account.dart';
import 'package:flutter/material.dart';
import 'screens/movie_home.dart';
import 'screens/music_home.dart';
import 'account/login_page.dart';
import 'account/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MusicProvider(),
        ),
      ],
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        title: 'CineLyric',
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
        routes: {
          '/home': (context) => HomePage(),
          '/movie': (context) => const MovieHome(),
          '/music': (context) => const MusicHome(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/history': (context) => const UserHistory(),
          '/landing': (context) => const LandingPage(),
          '/funfact': (context) => const FunFactPage(),
        },
      ),
    );
  }
}
