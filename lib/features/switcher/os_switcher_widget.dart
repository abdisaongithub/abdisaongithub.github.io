import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../os_mode/cubit/os_mode_cubit.dart';
import '../os_mode/os_mode.dart';

/// Floating OS picker.
///
/// It is positioned by [bottomInset] so it clears whatever chrome the active
/// shell puts along the bottom edge — it used to sit at a fixed 24px and so
/// covered the Windows taskbar, the macOS dock, the iOS dock and the Android
/// navigation bar.
class OSSwitcherWidget extends StatefulWidget {
  final double bottomInset;

  const OSSwitcherWidget({super.key, this.bottomInset = 24});

  @override
  State<OSSwitcherWidget> createState() => _OSSwitcherWidgetState();
}

class _OSSwitcherWidgetState extends State<OSSwitcherWidget> {
  bool _isExpanded = false;

  void _collapse() {
    if (_isExpanded) setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Tap anywhere else to dismiss, without blocking the UI when closed.
          if (_isExpanded)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _collapse,
              ),
            ),
          Positioned(
            right: 24,
            bottom: widget.bottomInset,
            child: BlocBuilder<OSModeCubit, OSModeState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isExpanded) ...[
                      _SwitcherPanel(
                        state: state,
                        onSelected: (mode) {
                          context.read<OSModeCubit>().setMode(mode);
                          _collapse();
                        },
                        onReset: () {
                          context.read<OSModeCubit>().resetToDetected();
                          _collapse();
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                    _SwitcherButton(
                      mode: state.mode,
                      isExpanded: _isExpanded,
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitcherButton extends StatelessWidget {
  final OSMode mode;
  final bool isExpanded;
  final VoidCallback onTap;

  const _SwitcherButton({
    required this.mode,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isExpanded ? 'Close' : 'Viewing ${mode.label} — switch OS',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: _Glass(
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                isExpanded ? Icons.close : mode.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitcherPanel extends StatelessWidget {
  final OSModeState state;
  final ValueChanged<OSMode> onSelected;
  final VoidCallback onReset;

  const _SwitcherPanel({
    required this.state,
    required this.onSelected,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return _Glass(
      borderRadius: BorderRadius.circular(18),
      child: ConstrainedBox(
        // Keeps the panel inside a 390px phone viewport.
        constraints: const BoxConstraints(maxWidth: 240),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'CHOOSE AN OS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            for (final mode in OSMode.values)
              _SwitcherRow(
                mode: mode,
                isActive: state.mode == mode,
                isDetected: state.detected == mode,
                onTap: () => onSelected(mode),
              ),
            if (state.isManual && !state.isNativeShell) ...[
              const Divider(height: 1, color: Colors.white24),
              _ResetRow(detected: state.detected, onTap: onReset),
            ],
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _SwitcherRow extends StatefulWidget {
  final OSMode mode;
  final bool isActive;
  final bool isDetected;
  final VoidCallback onTap;

  const _SwitcherRow({
    required this.mode,
    required this.isActive,
    required this.isDetected,
    required this.onTap,
  });

  @override
  State<_SwitcherRow> createState() => _SwitcherRowState();
}

class _SwitcherRowState extends State<_SwitcherRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: widget.isActive
              ? Colors.white.withValues(alpha: 0.18)
              : (_hovering
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent),
          child: Row(
            children: [
              Icon(
                widget.mode.icon,
                size: 18,
                color: widget.isActive ? Colors.white : Colors.white70,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.mode.label,
                  style: TextStyle(
                    color: widget.isActive ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight:
                        widget.isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Tells the visitor which shell matches their own machine.
              if (widget.isDetected) ...[
                const SizedBox(width: 6),
                const _YoursBadge(),
              ],
              if (widget.isActive) ...[
                const SizedBox(width: 6),
                const Icon(Icons.check, size: 15, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _YoursBadge extends StatelessWidget {
  const _YoursBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
        ),
      ),
      child: const Text(
        'YOURS',
        style: TextStyle(
          color: Color(0xFF8BE68F),
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ResetRow extends StatelessWidget {
  final OSMode detected;
  final VoidCallback onTap;

  const _ResetRow({required this.detected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.restart_alt, size: 16, color: Colors.white54),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Back to ${detected.shortLabel}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glass extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const _Glass({required this.child, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
