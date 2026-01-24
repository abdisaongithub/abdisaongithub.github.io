import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../os_mode/cubit/os_mode_cubit.dart';
import '../os_mode/os_mode.dart';

class OSSwitcherWidget extends StatefulWidget {
  const OSSwitcherWidget({super.key});

  @override
  State<OSSwitcherWidget> createState() => _OSSwitcherWidgetState();
}

class _OSSwitcherWidgetState extends State<OSSwitcherWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: BlocBuilder<OSModeCubit, OSModeState>(
        builder: (context, state) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Toggle Button (Current OS or Active Picker)
                      if (!_isExpanded)
                        _OSSwitcherTile(
                          mode: state.mode,
                          isSelected: true,
                          showLabel: false,
                          onTap: () => setState(() => _isExpanded = true),
                        )
                      else ...[
                        ...OSMode.values.map((mode) {
                          return _OSSwitcherTile(
                            mode: mode,
                            isSelected: state.mode == mode,
                            showLabel: false,
                            onTap: () {
                              context.read<OSModeCubit>().setMode(mode);
                              setState(() => _isExpanded = false);
                            },
                          );
                        }),
                        // Collapse Button
                        IconButton(
                          icon: const Icon(Icons.chevron_right,
                              color: Colors.white70, size: 20),
                          onPressed: () => setState(() => _isExpanded = false),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OSSwitcherTile extends StatefulWidget {
  final OSMode mode;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  const _OSSwitcherTile({
    required this.mode,
    required this.isSelected,
    this.showLabel = false,
    required this.onTap,
  });

  @override
  State<_OSSwitcherTile> createState() => _OSSwitcherTileState();
}

class _OSSwitcherTileState extends State<_OSSwitcherTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.white.withOpacity(0.25)
                : (_isHovering
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent),
            shape: BoxShape.circle,
          ),
          child: Tooltip(
            message: widget.mode.name.toUpperCase(),
            child: Icon(
              _getIconForMode(widget.mode),
              color: widget.isSelected ? Colors.white : Colors.white70,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForMode(OSMode mode) {
    switch (mode) {
      case OSMode.windows:
        return Icons.desktop_windows;
      case OSMode.macos:
        return Icons.laptop_mac;
      case OSMode.linux:
        return Icons.terminal;
      case OSMode.android:
        return Icons.android;
      case OSMode.ios:
        return Icons.phone_iphone;
      case OSMode.web:
        return Icons.language;
    }
  }
}
