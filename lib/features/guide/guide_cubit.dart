import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Things on screen the guide can point at. Each is marked in the widget tree
/// with a `GuideAnchor`.
enum GuideTarget { apps, terminal, switcher, portfolio }

class GuideStep extends Equatable {
  /// What to highlight. `null` shows the card centred with nothing ringed,
  /// for tips that have no single control (keyboard shortcuts).
  final GuideTarget? target;
  final String title;
  final String body;

  const GuideStep({
    required this.target,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [target, title, body];
}

class GuideState extends Equatable {
  final List<GuideStep> steps;
  final int index;

  /// True once the visitor has seen the OS guide, on this visit or a previous
  /// one, so it never reappears uninvited. It can still be reopened on demand.
  final bool osGuideSeen;

  const GuideState({
    this.steps = const [],
    this.index = 0,
    this.osGuideSeen = false,
  });

  bool get isOpen => steps.isNotEmpty;
  GuideStep? get current => isOpen ? steps[index] : null;
  bool get isFirst => index == 0;
  bool get isLast => index == steps.length - 1;

  GuideState copyWith({
    List<GuideStep>? steps,
    int? index,
    bool? osGuideSeen,
  }) {
    return GuideState(
      steps: steps ?? this.steps,
      index: index ?? this.index,
      osGuideSeen: osGuideSeen ?? this.osGuideSeen,
    );
  }

  @override
  List<Object?> get props => [steps, index, osGuideSeen];
}

/// Points out what a visitor can do. It highlights and explains; it never
/// clicks, types or navigates on anyone's behalf.
class GuideCubit extends Cubit<GuideState> {
  /// [preferences] is injectable so tests can simulate blocked storage.
  GuideCubit({Future<SharedPreferences> Function()? preferences})
      : _preferences = preferences ?? SharedPreferences.getInstance,
        super(const GuideState()) {
    _restored = _restoreSeen();
  }

  static const seenKey = 'guide.osSeen';

  final Future<SharedPreferences> Function() _preferences;
  late final Future<void> _restored;

  Future<void> _restoreSeen() async {
    try {
      final prefs = await _preferences();
      if ((prefs.getBool(seenKey) ?? false) && !isClosed) {
        emit(state.copyWith(osGuideSeen: true));
      }
    } catch (e) {
      // Private windows can block storage; the guide just shows again.
      debugPrint('Could not read guide preference: $e');
    }
  }

  Future<void> _persistSeen() async {
    try {
      final prefs = await _preferences();
      await prefs.setBool(seenKey, true);
    } catch (e) {
      debugPrint('Could not save guide preference: $e');
    }
  }

  void open(List<GuideStep> steps) {
    if (steps.isEmpty) return;
    emit(GuideState(steps: steps, osGuideSeen: true));
    unawaited(_persistSeen());
  }

  /// Opens the guide the first time a visitor lands in an OS shell.
  ///
  /// [steps] is resolved only after the stored preference has loaded, so it
  /// reflects the controls on screen at that moment.
  Future<void> showOSGuideOnce(List<GuideStep> Function() steps) async {
    await _restored;
    if (isClosed || state.osGuideSeen || state.isOpen) return;
    open(steps());
  }

  void next() {
    if (!state.isOpen) return;
    if (state.isLast) {
      dismiss();
      return;
    }
    emit(state.copyWith(index: state.index + 1));
  }

  void back() {
    if (!state.isOpen || state.isFirst) return;
    emit(state.copyWith(index: state.index - 1));
  }

  void dismiss() {
    if (!state.isOpen) return;
    emit(GuideState(osGuideSeen: state.osGuideSeen));
  }
}
