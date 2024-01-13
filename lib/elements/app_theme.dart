import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  // brightness: Brightness.light,

  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.blue,
      fontSize: 20,
    ),
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    centerTitle: true,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.blue,
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
    ),
  ),
  dividerColor: Colors.grey[300], // Adjust the divider color for light mode

  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

///////////////////////////////////////////////////////////////////////////

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey[800], // Adjust the FAB color for dark mode
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      fontSize: 35,
      color: Colors.white, // Adjust the text color for dark mode
    ),
    backgroundColor:
        Colors.black26, // Adjust the background color for dark mode
    centerTitle: true,
  ),
  iconTheme: IconThemeData(
    color: Colors.yellow,
  ),
  bottomAppBarTheme: BottomAppBarTheme(
    color: Colors.black87, // Adjust the color for dark mode
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow, // Adjust the button color for dark mode
    ),
  ),
  dividerColor: Colors.grey[800], // Adjust the divider color for dark mode
);
