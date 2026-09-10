import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../os_mode/cubit/os_mode_cubit.dart';
import '../os_mode/os_mode.dart';
import '../virtual_window/cubit/window_manager_cubit.dart';
import '../virtual_window/window_content.dart';

enum SpeedrunStatus {
  /// Never started, or dismissed before starting.
  idle,

  /// Offered but not yet accepted — the prompt is showing.
  offered,
  running,
  finished,
}

class SpeedrunState extends Equatable {
  final SpeedrunStatus status;
  final int step;
  final int total;
  final String label;

  /// A command the terminal should type out. Consumed by [TerminalApp].
  final String? typedCommand;

  const SpeedrunState({
    this.status = SpeedrunStatus.idle,
    this.step = 0,
    this.total = 0,
    this.label = '',
    this.typedCommand,
  });

  bool get isRunning => status == SpeedrunStatus.running;

  double get progress => total == 0 ? 0 : step / total;

  SpeedrunState copyWith({
    SpeedrunStatus? status,
    int? step,
    int? total,
    String? label,
    String? typedCommand,
    bool clearCommand = false,
  }) {
    return SpeedrunState(
      status: status ?? this.status,
      step: step ?? this.step,
      total: total ?? this.total,
      label: label ?? this.label,
      typedCommand: clearCommand ? null : (typedCommand ?? this.typedCommand),
    );
  }

  @override
  List<Object?> get props => [status, step, total, label, typedCommand];
}

/// Drives a scripted tour of the OS.
///
/// The shells are the most interesting thing here but they are also the least
/// discoverable — nothing tells a visitor that windows drag, that the terminal
/// is real, or that the OS can be swapped. This performs all of it in about
/// thirty seconds, and hands control back the moment anyone wants it.
class SpeedrunCubit extends Cubit<SpeedrunState> {
  SpeedrunCubit({
    required WindowManagerCubit windows,
    required OSModeCubit osMode,
    Future<void> Function(Duration)? delay,
  })  : _windows = windows,
        _osMode = osMode,
        _delay = delay ?? _realDelay,
        super(const SpeedrunState());

  final WindowManagerCubit _windows;
  final OSModeCubit _osMode;
  final Future<void> Function(Duration) _delay;

  bool _cancelled = false;

  static Future<void> _realDelay(Duration d) => Future<void>.delayed(d);

  static const WindowContent _portfolio = WindowContent(
    title: 'Portfolio — Abdisa Tsegaye',
    type: WindowContentType.portfolio,
  );
  static const WindowContent _projects = WindowContent(
    title: 'Projects',
    type: WindowContentType.projectDetail,
  );
  static const WindowContent _terminal = WindowContent(
    title: 'Terminal',
    type: WindowContentType.terminal,
  );

  /// Shows the invitation without starting anything.
  void offer() {
    if (state.status != SpeedrunStatus.idle) return;
    emit(state.copyWith(status: SpeedrunStatus.offered));
  }

  void dismiss() {
    if (state.status == SpeedrunStatus.running) return;
    emit(const SpeedrunState(status: SpeedrunStatus.finished));
  }

  /// Stops immediately and leaves everything where it is, so the visitor can
  /// carry on from whatever is on screen.
  void takeOver() {
    _cancelled = true;
    emit(state.copyWith(status: SpeedrunStatus.finished, clearCommand: true));
  }

  /// Clears a consumed terminal command so the same one is not replayed.
  void commandConsumed() {
    if (state.typedCommand == null) return;
    emit(state.copyWith(clearCommand: true));
  }

  Future<void> start() async {
    if (state.isRunning) return;
    _cancelled = false;

    final steps = _buildSteps();
    emit(
      SpeedrunState(
        status: SpeedrunStatus.running,
        total: steps.length,
        label: steps.first.label,
      ),
    );

    for (var i = 0; i < steps.length; i++) {
      if (_cancelled || isClosed) return;

      final step = steps[i];
      emit(state.copyWith(step: i, label: step.label));

      await step.run();
      if (_cancelled || isClosed) return;
    }

    if (isClosed) return;
    emit(
      state.copyWith(
        status: SpeedrunStatus.finished,
        step: steps.length,
        label: 'Done',
      ),
    );
  }

  List<_Step> _buildSteps() {
    // Somewhere other than the visitor's own platform, so the switch is
    // visibly a switch.
    final otherShell = OSMode.values.firstWhere(
      (mode) => mode != _osMode.state.mode && mode.isDesktop,
      orElse: () => OSMode.windows,
    );

    return [
      _Step('Opening the portfolio', () async {
        _windows.openWindow(_portfolio);
        await _delay(const Duration(milliseconds: 1400));
      }),
      _Step('Windows drag and resize', () async {
        final id = _idOf(WindowContentType.portfolio);
        if (id == null) return;
        await _drag(id, const Offset(9, 5), 26);
        await _delay(const Duration(milliseconds: 200));
        await _resize(id, const Offset(6, 3), 20);
        await _delay(const Duration(milliseconds: 400));
      }),
      _Step('Every project is real', () async {
        _windows.openWindow(_projects);
        await _delay(const Duration(milliseconds: 1600));
      }),
      _Step('The terminal actually works', () async {
        _windows.openWindow(_terminal);
        await _delay(const Duration(milliseconds: 700));
      }),
      _Step('Try it yourself', () async {
        emit(state.copyWith(typedCommand: 'about'));
        await _delay(const Duration(milliseconds: 2600));
      }),
      _Step('Swap the operating system', () async {
        _osMode.setMode(otherShell);
        // Let the boot transition play out.
        await _delay(const Duration(milliseconds: 1900));
      }),
      _Step('Back to the work', () async {
        final id = _idOf(WindowContentType.portfolio);
        if (id != null) _windows.focusWindow(id);
        await _delay(const Duration(milliseconds: 900));
      }),
    ];
  }

  String? _idOf(WindowContentType type) {
    for (final window in _windows.state.windows) {
      if (window.content.type == type) return window.id;
    }
    return null;
  }

  Future<void> _drag(String id, Offset perFrame, int frames) async {
    for (var i = 0; i < frames; i++) {
      if (_cancelled || isClosed) return;
      _windows.moveWindow(id, perFrame);
      await _delay(const Duration(milliseconds: 16));
    }
  }

  Future<void> _resize(String id, Offset perFrame, int frames) async {
    for (var i = 0; i < frames; i++) {
      if (_cancelled || isClosed) return;
      _windows.resizeWindow(id, perFrame);
      await _delay(const Duration(milliseconds: 16));
    }
  }

  @override
  Future<void> close() {
    _cancelled = true;
    return super.close();
  }
}

class _Step {
  final String label;
  final Future<void> Function() run;

  _Step(this.label, this.run);
}
