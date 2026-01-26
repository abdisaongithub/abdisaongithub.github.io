import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  ThemeCubit() : super(ThemeState.initial());

  void setWallpaper(String assetPath) {
    emit(state.copyWith(wallpaper: assetPath));
  }

  void toggleTheme() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
