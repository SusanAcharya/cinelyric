// apptheme.dart
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  // Define your light theme here
  primaryColor: Colors.white,
  brightness: Brightness.light,
  textTheme: TextTheme(
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ),
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: Color.fromRGBO(48, 53, 147, 1),
    centerTitle: true,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color.fromRGBO(48, 53, 147, 1),
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(60, 104, 177, 1),
    ),
  ),

  // primarySwatch: Colors.blue,
  // visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData darkTheme = ThemeData(
  // primaryColor: Colors.black,
  brightness: Brightness.dark,
  primaryColorDark: Colors.black,
  // Define your dark theme here
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      // backgroundColor: Colors.blueGrey,
      ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    // backgroundColor: Color.fromRGBO(199, 235, 247, 1),
    backgroundColor: Color.fromRGBO(159, 18, 57, 1),
    centerTitle: true,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color.fromRGBO(159, 18, 57, 1),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromRGBO(159, 18, 57, 1),
      textStyle: TextStyle(
        color: Colors.black,
      ),
    ),
  ),
  textTheme: TextTheme(
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ),
  ),

  //darktheme:-
  // primarySwatch: Colors.yellow,
  // visualDensity: VisualDensity.adaptivePlatformDensity,
);
