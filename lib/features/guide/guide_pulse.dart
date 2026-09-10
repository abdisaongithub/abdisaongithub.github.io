import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';

/// A soft ring that ripples out from a pill-shaped control now and then, to
/// draw the eye without moving anything. The landing page uses it on
/// "Enter the OS" until the visitor has been inside.
class GuidePulse extends StatefulWidget {
  final bool active;
  final Widget child;

  const GuidePulse({super.key, required this.active, required this.child});

  @override
  State<GuidePulse> createState() => _GuidePulseState();
}

class _GuidePulseState extends State<GuidePulse>
    with SingleTickerProviderStateMixin {
  // Created in initState, not lazily: returning visitors never activate it,
  // and a lazy controller first touched in dispose() throws.
  late final AnimationController _controller;

  // The ripple takes the first half of each cycle; the rest is a pause, so it
  // reads as a nudge rather than a flashing light.
  static const _ripple = Interval(0, 0.5, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(GuidePulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;

    return CustomPaint(
      foregroundPainter: _RipplePainter(_controller),
      child: widget.child,
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> progress;

  _RipplePainter(this.progress) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final t = _GuidePulseState._ripple.transform(progress.value);
    if (t <= 0 || t >= 1) return;

    final spread = 8 * t;
    final rect = (Offset.zero & size).inflate(spread);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.accentBright.withValues(alpha: 0.8 * (1 - t)),
    );
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
