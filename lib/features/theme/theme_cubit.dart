import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// STATE
class ThemeState extends Equatable {
  final String wallpaper;
  final bool isDarkMode;

  const ThemeState({
    required this.wallpaper,
    required this.isDarkMode,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      wallpaper: 'assets/images/windows_wallpaper.jpg',
      isDarkMode: true,
    );
  }

  ThemeState copyWith({
    String? wallpaper,
    bool? isDarkMode,
  }) {
    return ThemeState(
      wallpaper: wallpaper ?? this.wallpaper,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object> get props => [wallpaper, isDarkMode];
}

// CUBIT
class ThemeCubit extends Cubit<ThemeState> {
  static const _wallpaperKey = 'selected_wallpaper';
  static const _darkModeKey = 'is_dark_mode';

  ThemeCubit() : super(ThemeState.initial()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final wallpaper = prefs.getString(_wallpaperKey);
    final isDarkMode = prefs.getBool(_darkModeKey);

    if (wallpaper != null || isDarkMode != null) {
      emit(state.copyWith(
        wallpaper: wallpaper ?? state.wallpaper,
        isDarkMode: isDarkMode ?? state.isDarkMode,
      ));
    }
  }

  Future<void> setWallpaper(String assetPath) async {
    emit(state.copyWith(wallpaper: assetPath));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wallpaperKey, assetPath);
  }

  Future<void> toggleTheme() async {
    final newMode = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newMode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, newMode);
  }
}
