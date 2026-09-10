import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/features/guide/guide_pulse.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget pulse({required bool active}) => MaterialApp(
        home: Center(
          child: GuidePulse(
            active: active,
            child: const SizedBox(width: 120, height: 36),
          ),
        ),
      );

  // Returning visitors never activate the pulse. It used to create its
  // controller lazily, so the first touch happened in dispose() and threw.
  testWidgets('an inactive pulse mounts and unmounts cleanly', (tester) async {
    await tester.pumpWidget(pulse(active: false));
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('stops rippling once the visitor has been inside',
      (tester) async {
    await tester.pumpWidget(pulse(active: true));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpWidget(pulse(active: false));
    await tester.pump();
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
}
