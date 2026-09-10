import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_cubit.dart';

/// Wallpaper layer driven by [ThemeCubit].
///
/// Every desktop and launcher used to inline its own `DecorationImage`, which
/// meant a missing or empty asset path threw an uncatchable image exception.
/// This renders a gradient instead when there is no usable wallpaper.
class DesktopWallpaper extends StatelessWidget {
  const DesktopWallpaper({super.key, this.fallback});

  final Gradient? fallback;

  static const Gradient _defaultFallback = LinearGradient(
    colors: [Color(0xFF1F1147), Color(0xFF0B0B14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.wallpaper != current.wallpaper,
      builder: (context, state) {
        if (state.wallpaper.isEmpty) return _gradient();

        return Image.asset(
          state.wallpaper,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _gradient(),
        );
      },
    );
  }

  Widget _gradient() {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: fallback ?? _defaultFallback),
    );
  }
}
