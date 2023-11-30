import 'package:cinelyric/pages/home_page.dart';
import 'package:cinelyric/pages/landing_page.dart';
import 'package:cinelyric/pages/account/user_history.dart';
import 'package:flutter/material.dart';
import 'pages/movie_home.dart';
import 'pages/music_home.dart';
import 'pages/account/login_page.dart';
import 'pages/account/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(240, 255, 255, 1),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontSize: 35, color: Colors.black87),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(199, 235, 247, 1),
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
            color: Color.fromRGBO(199, 235, 247, 1),
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
      },
    );
  }
}
