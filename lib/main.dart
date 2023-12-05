import 'package:cinelyric/screens/home_page.dart';
import 'package:cinelyric/screens/landing_page.dart';
import 'package:cinelyric/account/user_history.dart';
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
    return MaterialApp(
      theme: ThemeData(
          // scaffoldBackgroundColor: Color.fromRGBO(240, 255, 255, 1),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 35,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            // backgroundColor: Color.fromRGBO(199, 235, 247, 1),
            backgroundColor: Color.fromRGBO(48, 53, 147, 1),
            centerTitle: true,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
            color: Color.fromRGBO(48, 53, 147, 1),
          )),
      title: 'CineLyric',
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/movie': (context) => MovieHome(),
        '/music': (context) => MusicHome(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/history': (context) => UserHistory(),
        'landing': (context) => LandingPage(),
      },
    );
  }
}
