import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/os_mode/cubit/os_mode_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';

void main() {
  late OSModeCubit cubit;

  setUp(() => cubit = OSModeCubit());
  tearDown(() => cubit.close());

  test('starts on macOS in adaptive mode', () {
    expect(cubit.state.mode, OSMode.macos);
    expect(cubit.state.isManual, isFalse);
  });

  test('setMode marks the choice as manual by default', () {
    cubit.setMode(OSMode.windows);

    expect(cubit.state.mode, OSMode.windows);
    expect(cubit.state.isManual, isTrue);
  });

  test('switching between mobile modes inherits the simulation state', () {
    cubit.setMode(OSMode.android, isManual: false);
    cubit.setMode(OSMode.ios);

    expect(cubit.state.mode, OSMode.ios);
    expect(
      cubit.state.isManual,
      isFalse,
      reason: 'Android -> iOS should not force the phone frame on.',
    );
  });

  test('desktop to mobile respects the requested manual flag', () {
    cubit.setMode(OSMode.windows);
    cubit.setMode(OSMode.android, isManual: false);

    expect(cubit.state.isManual, isFalse);
  });

  test('toggleMode cycles through every mode and wraps', () {
    final seen = <OSMode>[cubit.state.mode];
    for (var i = 0; i < OSMode.values.length; i++) {
      cubit.toggleMode();
      seen.add(cubit.state.mode);
    }

    expect(seen.toSet(), OSMode.values.toSet());
    expect(seen.last, seen.first, reason: 'A full cycle should wrap around.');
  });
}
