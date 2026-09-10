import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';
import '../os_mode/os_mode.dart';

/// Boot transition into an OS shell.
///
/// This used to be the app's front door, with a login screen behind it — two
/// full screens between a visitor and any actual content. It now plays only
/// when someone deliberately enters a shell, and it is short.
class BootScreen extends StatefulWidget {
  final OSMode mode;
  final VoidCallback onComplete;

  const BootScreen({
    super.key,
    required this.mode,
    required this.onComplete,
  });

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> _logs = [];

  /// Per-line delay. The old sequence ran 17 lines and took several seconds;
  /// this is a transition, so it stays under a second in total.
  static const Duration _lineDelay = Duration(milliseconds: 42);

  List<String> get _sequence => [
        'ABDISA BIOS v2.0 — ${widget.mode.label}',
        'CPU: Flutter Web Engine .......... OK',
        'Memory .......................... OK',
        'Mounting /home/abdisa ........... OK',
        'Loading window manager .......... OK',
        'Starting ${widget.mode.label} ...',
      ];

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    for (final line in _sequence) {
      await Future<void>.delayed(_lineDelay);
      if (!mounted) return;
      setState(() => _logs.add(line));
    }

    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in _logs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      line,
                      style: const TextStyle(
                        color: Color(0xFF8AE234),
                        fontFamily: 'monospace',
                        fontFamilyFallback: ['Consolas', 'Menlo'],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                const _Cursor(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cursor extends StatefulWidget {
  const _Cursor();

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(width: 8, height: 15, color: const Color(0xFF8AE234)),
    );
  }
}
