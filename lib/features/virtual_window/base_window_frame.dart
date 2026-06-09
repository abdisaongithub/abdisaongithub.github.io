import 'package:flutter/material.dart';

enum WindowButtonStyle { windows, mac, linux }

class BaseWindowFrame extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final WindowButtonStyle style;
  final Widget? icon;

  const BaseWindowFrame({
    super.key,
    required this.title,
    required this.onClose,
    required this.onMinimize,
    required this.onMaximize,
    required this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case WindowButtonStyle.mac:
        return _buildMacFrame();
      case WindowButtonStyle.linux:
        return _buildLinuxFrame();
      case WindowButtonStyle.windows:
      default:
        return _buildWindowsFrame();
    }
  }

  Widget _buildWindowsFrame() {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            const SizedBox(width: 10),
            SizedBox(width: 16, height: 16, child: icon),
          ],
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          _WindowsButton(icon: Icons.remove, onTap: onMinimize),
          _WindowsButton(icon: Icons.check_box_outline_blank, onTap: onMaximize),
          _WindowsButton(icon: Icons.close, onTap: onClose, isClose: true),
        ],
      ),
    );
  }

  Widget _buildMacFrame() {
    return Container(
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFFEBEBEB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          _MacStoplight(color: const Color(0xFFFF5F56), onTap: onClose),
          const SizedBox(width: 8),
          _MacStoplight(color: const Color(0xFFFFBD2E), onTap: onMinimize),
          const SizedBox(width: 8),
          _MacStoplight(color: const Color(0xFF27C93F), onTap: onMaximize),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 60), // Balance the stoplights
        ],
      ),
    );
  }

  Widget _buildLinuxFrame() {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFF3E3E3E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _LinuxButton(icon: Icons.remove, onTap: onMinimize),
          _LinuxButton(icon: Icons.crop_square, onTap: onMaximize),
          _LinuxButton(icon: Icons.close, onTap: onClose, isClose: true),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _WindowsButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;

  const _WindowsButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_WindowsButton> createState() => _WindowsButtonState();
}

class _WindowsButtonState extends State<_WindowsButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 32,
          color: _hovering
              ? (widget.isClose ? const Color(0xFFC42B1C) : const Color(0xFFE5E5E5))
              : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 14,
            color: _hovering && widget.isClose ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _MacStoplight extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _MacStoplight({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _LinuxButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;

  const _LinuxButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isClose ? const Color(0xFFE95420) : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}
