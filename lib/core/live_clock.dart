import 'dart:async';

import 'package:flutter/material.dart';

/// A clock that ticks on the minute.
///
/// Every shell used to hardcode its own time — "9:41 AM" on macOS and iOS,
/// "12:00" on Android.
class LiveClock extends StatefulWidget {
  final TextStyle? style;

  /// Append AM/PM, as macOS and iOS do.
  final bool showMeridiem;

  const LiveClock({super.key, this.style, this.showMeridiem = false});

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _scheduleTick();
  }

  /// Sleeps until the next minute boundary rather than polling every second.
  void _scheduleTick() {
    final now = DateTime.now();
    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    ).add(const Duration(minutes: 1));

    _timer = Timer(nextMinute.difference(now), () {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
      _scheduleTick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hour = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
    final minute = _now.minute.toString().padLeft(2, '0');
    final suffix = widget.showMeridiem ? (_now.hour < 12 ? ' AM' : ' PM') : '';

    return Text(
      '$hour:$minute$suffix',
      style: widget.style ??
          const TextStyle(color: Colors.white, fontSize: 13, height: 1.0),
    );
  }
}
