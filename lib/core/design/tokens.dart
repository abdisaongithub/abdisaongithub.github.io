import 'package:flutter/material.dart';

/// Design tokens.
///
/// Every colour, radius, spacing step and duration in the portfolio surfaces
/// comes from here. Before this existed, each screen invented its own values —
/// eight different corner radii, four greys, ad-hoc paddings — which is why the
/// UI never looked like one product.
class AppColors {
  const AppColors._();

  // Surfaces — a near-black neutral ramp with a very slight blue cast, which
  // reads as "deliberate dark theme" rather than "pure black".
  static const Color bg = Color(0xFF08080B);
  static const Color surface = Color(0xFF0E0E13);
  static const Color surfaceRaised = Color(0xFF15151C);
  static const Color surfaceOverlay = Color(0xFF1C1C26);

  // Hairlines
  static const Color border = Color(0xFF23232E);
  static const Color borderStrong = Color(0xFF32323F);

  // Text
  static const Color textPrimary = Color(0xFFF4F4F6);
  static const Color textSecondary = Color(0xFFA1A1AE);
  static const Color textTertiary = Color(0xFF6B6B78);

  // Brand — a single accent, used sparingly so it still means something.
  static const Color accent = Color(0xFF6E56CF);
  static const Color accentBright = Color(0xFF9E8CFC);
  static const Color accentSoft = Color(0x1A6E56CF);

  static const Color success = Color(0xFF3DD68C);
  static const Color successSoft = Color(0x1A3DD68C);
  static const Color warning = Color(0xFFFFB224);

  static const Color spotify = Color(0xFF1DB954);

  /// Ambient hero wash.
  static const List<Color> heroMesh = [
    Color(0xFF6E56CF),
    Color(0xFF2E7DD1),
    Color(0xFFB44DBF),
  ];
}

class AppSpacing {
  const AppSpacing._();

  /// 4pt base scale.
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 80;

  /// Page gutters by viewport.
  static double gutter(double width) {
    if (width < 600) return 20;
    if (width < 1100) return 40;
    return 64;
  }

  /// Content never stretches past this, so text stays readable on wide screens.
  static const double maxContentWidth = 1180;
}

class AppRadius {
  const AppRadius._();

  static const Radius sm = Radius.circular(8);
  static const Radius md = Radius.circular(12);
  static const Radius lg = Radius.circular(18);
  static const Radius xl = Radius.circular(28);

  static const BorderRadius allSm = BorderRadius.all(sm);
  static const BorderRadius allMd = BorderRadius.all(md);
  static const BorderRadius allLg = BorderRadius.all(lg);
  static const BorderRadius allXl = BorderRadius.all(xl);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 480);

  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
}

/// Type scale. Sizes step by roughly 1.25 so headings feel related.
class AppText {
  const AppText._();

  static TextStyle display(double width) => TextStyle(
        fontSize: width < 480
            ? 38
            : width < 900
                ? 54
                : 72,
        height: 1.04,
        letterSpacing: -1.8,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static const TextStyle h1 = TextStyle(
    fontSize: 34,
    height: 1.15,
    letterSpacing: -0.8,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    height: 1.25,
    letterSpacing: -0.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    height: 1.3,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 1.65,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 14,
    height: 1.55,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle mono = TextStyle(
    fontSize: 13,
    height: 1.5,
    fontFamily: 'monospace',
    fontFamilyFallback: ['Consolas', 'Menlo', 'Courier New'],
    color: AppColors.textSecondary,
  );

  /// Small all-caps section marker.
  static const TextStyle eyebrow = TextStyle(
    fontSize: 11,
    height: 1.2,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w700,
    color: AppColors.textTertiary,
  );
}

/// Shared decorations so cards, panels and popovers match everywhere.
class AppDecoration {
  const AppDecoration._();

  static BoxDecoration card({bool hovered = false}) => BoxDecoration(
        color: hovered ? AppColors.surfaceRaised : AppColors.surface,
        borderRadius: AppRadius.allLg,
        border: Border.all(
          color: hovered ? AppColors.borderStrong : AppColors.border,
        ),
      );

  static BoxDecoration panel = BoxDecoration(
    color: AppColors.surfaceRaised,
    borderRadius: AppRadius.allLg,
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 32,
        offset: const Offset(0, 12),
      ),
    ],
  );

  static BoxDecoration chip = BoxDecoration(
    color: AppColors.surfaceOverlay,
    borderRadius: AppRadius.pill,
    border: Border.all(color: AppColors.border),
  );
}
