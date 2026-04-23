import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  

class AppTheme {
  // Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.barlowCondensedTextTheme(),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.grey.shade100,
  );

  // Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.barlowCondensedTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme, 
    ),
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardColor: Colors.grey.shade900,
  );
}