import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Colours {
  static Color dark = const Color.fromARGB(255, 24, 26, 63);
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      textTheme: TextTheme(),
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber, disabledColor: Colors.black));

  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColor: Colors.amber,
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: TextTheme(),
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber, disabledColor: Colors.black));
}
