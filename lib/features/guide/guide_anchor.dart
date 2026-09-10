import 'package:flutter/widgets.dart';

import 'guide_cubit.dart';

/// Marks a widget as something the guide can highlight.
///
/// Anchors register themselves in [GuideAnchors] while mounted, so the guide
/// can find where a control is on screen without each shell passing keys
/// around. Wrapping costs nothing when no guide is open.
class GuideAnchor extends StatefulWidget {
  final GuideTarget target;
  final Widget child;

  const GuideAnchor({super.key, required this.target, required this.child});

  @override
  State<GuideAnchor> createState() => _GuideAnchorState();
}

class _GuideAnchorState extends State<GuideAnchor> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    GuideAnchors._register(widget.target, _key);
  }

  @override
  void didUpdateWidget(GuideAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      GuideAnchors._unregister(oldWidget.target, _key);
      GuideAnchors._register(widget.target, _key);
    }
  }

  @override
  void dispose() {
    GuideAnchors._unregister(widget.target, _key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}

/// Where the guide's targets currently are.
class GuideAnchors {
  const GuideAnchors._();

  static final Map<GuideTarget, GlobalKey> _keys = {};

  static void _register(GuideTarget target, GlobalKey key) {
    _keys[target] = key;
  }

  static void _unregister(GuideTarget target, GlobalKey key) {
    // During a cross-fade the incoming shell registers before the outgoing one
    // disposes; only remove the entry if it is still ours.
    if (identical(_keys[target], key)) _keys.remove(target);
  }

  static bool isMounted(GuideTarget target) =>
      _keys[target]?.currentContext != null;

  /// Drops steps whose control is not on screen in the current shell (there
  /// is no "back to portfolio" button on a phone, for example).
  static List<GuideStep> available(List<GuideStep> steps) => [
        for (final step in steps)
          if (step.target == null || isMounted(step.target!)) step,
      ];

  /// The target's bounds in [relativeTo]'s coordinate space, accounting for
  /// transforms such as the scaled phone frame.
  static Rect? rectOf(GuideTarget target, BuildContext relativeTo) {
    final box = _keys[target]?.currentContext?.findRenderObject();
    final origin = relativeTo.findRenderObject();
    if (box is! RenderBox ||
        origin is! RenderBox ||
        !box.attached ||
        !origin.attached ||
        !box.hasSize ||
        !origin.hasSize) {
      return null;
    }

    final topLeft = origin.globalToLocal(box.localToGlobal(Offset.zero));
    final bottomRight = origin.globalToLocal(
      box.localToGlobal(box.size.bottomRight(Offset.zero)),
    );
    return Rect.fromPoints(topLeft, bottomRight);
  }
}
