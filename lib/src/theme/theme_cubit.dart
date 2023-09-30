import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState.light());

  // THEMES
  // light
  final _lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  //dark
  final _darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
    ),
  );

  toggleMode(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isDarkMode) {
      emit(const ThemeState.light());
    } else {
      emit(const ThemeState.dark());
    }
  }

  ThemeData getLightMode() {
    return _lightTheme;
  }

  ThemeData getDarkMode() {
    return _darkTheme;
  }
}
