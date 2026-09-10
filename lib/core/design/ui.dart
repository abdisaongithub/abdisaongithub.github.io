import 'package:flutter/material.dart';

import 'tokens.dart';

/// Rebuilds its child with the current hover state. Every interactive surface
/// in the app used to hand-roll a StatefulWidget with a `_hovering` bool.
class Hoverable extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor cursor;

  const Hoverable({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: widget.builder(context, _hovered),
      ),
    );
  }
}

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final bool dense;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onPressed,
      builder: (context, hovered) {
        final colors = _colorsFor(hovered);

        return AnimatedContainer(
          duration: AppMotion.fast,
          padding: EdgeInsets.symmetric(
            horizontal: dense ? AppSpacing.md : AppSpacing.lg,
            vertical: dense ? 9 : 14,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: AppRadius.pill,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: dense ? 15 : 17, color: colors.foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: dense ? 13 : 14.5,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ({Color background, Color foreground, Color border}) _colorsFor(
    bool hovered,
  ) {
    switch (variant) {
      case AppButtonVariant.primary:
        return (
          background: hovered ? AppColors.accentBright : AppColors.accent,
          foreground: Colors.white,
          border: hovered ? AppColors.accentBright : AppColors.accent,
        );
      case AppButtonVariant.secondary:
        return (
          background:
              hovered ? AppColors.surfaceOverlay : AppColors.surfaceRaised,
          foreground: AppColors.textPrimary,
          border: hovered ? AppColors.borderStrong : AppColors.border,
        );
      case AppButtonVariant.ghost:
        return (
          background: hovered ? AppColors.surfaceRaised : Colors.transparent,
          foreground: hovered ? AppColors.textPrimary : AppColors.textSecondary,
          border: Colors.transparent,
        );
    }
  }
}

/// Small pill used for tech tags and metadata.
class AppChip extends StatelessWidget {
  final String label;
  final Color? accent;
  final IconData? icon;

  const AppChip({super.key, required this.label, this.accent, this.icon});

  @override
  Widget build(BuildContext context) {
    final color = accent ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent?.withValues(alpha: 0.10) ?? AppColors.surfaceOverlay,
        borderRadius: AppRadius.pill,
        border: Border.all(
          color: accent?.withValues(alpha: 0.28) ?? AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Eyebrow + heading pair that opens every section.
class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow.toUpperCase(), style: AppText.eyebrow),
        const SizedBox(height: AppSpacing.sm + 2),
        Text(title, style: AppText.h1),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm + 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(subtitle!, style: AppText.body),
          ),
        ],
      ],
    );
  }
}

/// Constrains content and applies the responsive gutter, so every section
/// lines up on the same left edge.
class ContentShell extends StatelessWidget {
  final Widget child;
  final double verticalPadding;

  const ContentShell({
    super.key,
    required this.child,
    this.verticalPadding = AppSpacing.xxxl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter(constraints.maxWidth),
            vertical: verticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// A soft radial wash used behind the hero. Cheap — no animation loop, so it
/// costs nothing on low-end devices.
class MeshBackdrop extends StatelessWidget {
  final double opacity;

  const MeshBackdrop({super.key, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Stack(
          children: [
            Positioned(
              top: -220,
              right: -140,
              child: _Blob(color: AppColors.heroMesh[0], size: 620),
            ),
            Positioned(
              top: 40,
              left: -200,
              child: _Blob(color: AppColors.heroMesh[1], size: 520),
            ),
            Positioned(
              top: 320,
              right: 120,
              child: _Blob(color: AppColors.heroMesh[2], size: 380),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.30), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

/// Fades and lifts its child in once, on first build.
class FadeInUp extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInUp({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.slow,
  );

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.emphasized,
    );

    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 18 * (1 - curved.value)),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
