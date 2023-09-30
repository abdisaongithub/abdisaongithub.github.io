import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    // primaryColorLight: CustomColor.redo,
    // primaryColorDark: CustomColor.redo,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: CustomColor.redo,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: CustomColor.redo,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: CustomColor.redo,
      selectionColor: CustomColor.redo,
      selectionHandleColor: CustomColor.redo,
    ),
    // splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      titleSpacing: -5,
      iconTheme: IconThemeData(
        color: Color.fromRGBO(120, 120, 120, 1),
      ),
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      toolbarTextStyle: TextStyle(
        color: CustomColor.bluoDark,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      titleTextStyle: TextStyle(
        color: CustomColor.bluoDark,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    ),
    fontFamily: 'Montserrat',
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(120, 120, 120, 1),
    ),
    textTheme: GoogleFonts.montserratTextTheme(),
  );
}
