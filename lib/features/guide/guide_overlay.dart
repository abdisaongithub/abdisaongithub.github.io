import 'dart:math' as math;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/tokens.dart';
import '../../core/design/ui.dart';
import 'guide_anchor.dart';
import 'guide_cubit.dart';

/// Dims the screen, rings the current step's control and explains it.
///
/// Only the card takes pointer input. The dimming lets every tap through, so
/// the highlighted control — and everything else — stays usable: the visitor
/// tries things themselves, the guide only points.
///
/// Must be a direct child of a full-screen `Stack`.
class GuideOverlay extends StatefulWidget {
  const GuideOverlay({super.key});

  @override
  State<GuideOverlay> createState() => _GuideOverlayState();
}

class _GuideOverlayState extends State<GuideOverlay>
    with SingleTickerProviderStateMixin {
  // Created in initState, not lazily: a lazy controller first touched in
  // dispose() looks up TickerMode on a deactivated element and throws.
  late final AnimationController _pulse;

  final FocusNode _focus = FocusNode(debugLabel: 'guide');
  final GlobalKey _surfaceKey = GlobalKey();
  Rect? _rect;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..addListener(_trackTarget);
    // The shell is rebuilt behind an open guide when the window resizes past
    // a breakpoint; pick up where it was rather than waiting for a change.
    if (context.read<GuideCubit>().state.isOpen) _start();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _start() {
    _pulse.repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  void _stop() {
    _pulse.stop();
    _rect = null;
  }

  /// Runs every animation frame while open, so the ring follows its control
  /// through window drags, resizes and viewport changes.
  void _trackTarget() {
    final target = context.read<GuideCubit>().state.current?.target;
    final surface = _surfaceKey.currentContext;
    final next = target == null || surface == null
        ? null
        : GuideAnchors.rectOf(target, surface);
    if (next != _rect) setState(() => _rect = next);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuideCubit, GuideState>(
      listenWhen: (previous, current) => previous.isOpen != current.isOpen,
      listener: (context, state) => state.isOpen ? _start() : _stop(),
      builder: (context, state) {
        final step = state.current;
        if (step == null) return const SizedBox.shrink();

        final cubit = context.read<GuideCubit>();
        // Unmeasured yet, or a tip with no control: card centred, no ring.
        final rect = step.target == null ? null : _rect;

        return Positioned.fill(
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.escape): cubit.dismiss,
              const SingleActivator(LogicalKeyboardKey.enter): cubit.next,
              const SingleActivator(LogicalKeyboardKey.arrowRight): cubit.next,
              const SingleActivator(LogicalKeyboardKey.arrowLeft): cubit.back,
            },
            child: Focus(
              focusNode: _focus,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  key: _surfaceKey,
                  children: [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _SpotlightPainter(
                            hole: rect,
                            pulse: _pulse,
                          ),
                        ),
                      ),
                    ),
                    _placeCard(
                      size: constraints.biggest,
                      spot: rect?.inflate(_SpotlightPainter.padding),
                      child: _GuideCard(
                        key: ValueKey(state.index),
                        state: state,
                        onNext: cubit.next,
                        onBack: cubit.back,
                        onClose: cubit.dismiss,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static const double _cardWidth = 320;
  // Laid out before its height is known; generous enough for three lines of
  // body text so a card placed below a control never runs off the screen.
  static const double _cardHeight = 230;
  static const double _gap = 16;
  static const double _margin = 16;

  /// Below the control if it fits, then above, then beside it. A control that
  /// fills the screen gets the card pinned to the bottom edge.
  static Widget _placeCard({
    required Size size,
    required Rect? spot,
    required Widget child,
  }) {
    final width = math.max(0.0, math.min(size.width - _margin * 2, _cardWidth));

    if (spot == null) {
      return Center(child: SizedBox(width: width, child: child));
    }

    final centredLeft = clampDouble(
      spot.center.dx - width / 2,
      _margin,
      math.max(_margin, size.width - width - _margin),
    );

    if (size.height - spot.bottom - _gap - _margin >= _cardHeight) {
      return Positioned(
        left: centredLeft,
        top: spot.bottom + _gap,
        width: width,
        child: child,
      );
    }

    if (spot.top - _gap - _margin >= _cardHeight) {
      return Positioned(
        left: centredLeft,
        bottom: size.height - spot.top + _gap,
        width: width,
        child: child,
      );
    }

    final besideTop = clampDouble(
      spot.center.dy - _cardHeight / 2,
      _margin,
      math.max(_margin, size.height - _cardHeight - _margin),
    );

    if (size.width - spot.right - _gap - _margin >= width) {
      return Positioned(
        left: spot.right + _gap,
        top: besideTop,
        width: width,
        child: child,
      );
    }

    if (spot.left - _gap - _margin >= width) {
      return Positioned(
        left: spot.left - _gap - width,
        top: besideTop,
        width: width,
        child: child,
      );
    }

    return Positioned(
      left: centredLeft,
      bottom: _margin,
      width: width,
      child: child,
    );
  }
}

class _GuideCard extends StatelessWidget {
  final GuideState state;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const _GuideCard({
    super.key,
    required this.state,
    required this.onNext,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final step = state.current!;

    return FadeInUp(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.md,
          ),
          decoration: AppDecoration.panel,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'TIP ${state.index + 1} OF ${state.steps.length}',
                    style: AppText.eyebrow,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onClose,
                    tooltip: 'Close (Esc)',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 17,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title, style: AppText.h3),
                    const SizedBox(height: AppSpacing.xs),
                    Text(step.body, style: AppText.bodySm),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        if (!state.isFirst)
                          AppButton(
                            label: 'Back',
                            variant: AppButtonVariant.ghost,
                            dense: true,
                            onPressed: onBack,
                          ),
                        const Spacer(),
                        AppButton(
                          label: state.isLast ? 'Got it' : 'Next',
                          dense: true,
                          onPressed: onNext,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  static const double padding = 8;

  final Rect? hole;
  final Animation<double> pulse;

  _SpotlightPainter({required this.hole, required this.pulse})
      : super(repaint: pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final dim = Paint()..color = Colors.black.withValues(alpha: 0.5);
    final screen = Offset.zero & size;

    final target = hole;
    if (target == null) {
      canvas.drawRect(screen, dim);
      return;
    }

    final cutout = RRect.fromRectAndRadius(
      target.inflate(padding),
      const Radius.circular(14),
    );
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(screen)
        ..addRRect(cutout),
      dim,
    );

    canvas.drawRRect(
      cutout,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.accentBright,
    );

    final t = Curves.easeOut.transform(pulse.value);
    canvas.drawRRect(
      cutout.inflate(10 * t),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.accentBright.withValues(alpha: 0.6 * (1 - t)),
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.hole != hole || oldDelegate.pulse != pulse;
}
