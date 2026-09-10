import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/os_mode/cubit/os_mode_cubit.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';

import '../../../support/test_harness.dart';

void main() {
  OSModeCubit cubitFor(OSMode detected, {bool isHandset = false}) =>
      OSModeCubit(detect: () => detectedIs(detected, isHandset: isHandset));

  group('initial routing', () {
    // The app used to hardcode macOS for everyone, so a Windows visitor was
    // dropped into a Mac desktop.
    for (final mode in OSMode.values) {
      test('a $mode visitor lands on the $mode shell', () {
        final cubit = cubitFor(mode);
        addTearDown(cubit.close);

        expect(cubit.state.mode, mode);
        expect(cubit.state.detected, mode);
        expect(cubit.state.isManual, isFalse);
        expect(cubit.state.isNativeShell, isTrue);
      });
    }
  });

  group('landing first', () {
    // A recruiter used to hit a BIOS animation and a login screen before any
    // content. The landing page is now the default surface.
    test('starts on the landing page, not in an OS shell', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      expect(cubit.state.isInOS, isFalse);
      expect(cubit.state.isBooting, isFalse);
      expect(cubit.state.showsPhoneFrame, isFalse);
    });

    test('entering an OS plays the boot transition', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.macos);

      expect(cubit.state.isInOS, isTrue);
      expect(cubit.state.isBooting, isTrue);
      expect(cubit.state.mode, OSMode.macos);
    });

    test('bootComplete ends the transition and keeps the shell', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.linux);
      cubit.bootComplete();

      expect(cubit.state.isBooting, isFalse);
      expect(cubit.state.isInOS, isTrue);
    });

    test('exitToLanding returns to the portfolio', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.windows);
      cubit.exitToLanding();

      expect(cubit.state.isInOS, isFalse);
      expect(cubit.state.isBooting, isFalse);
    });

    test('switching shells while inside does not replay the boot', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.windows);
      cubit.bootComplete();
      cubit.setMode(OSMode.macos);

      expect(cubit.state.isBooting, isFalse);
      expect(cubit.state.mode, OSMode.macos);
    });
  });

  group('phone frame', () {
    test('a real Android phone renders full-bleed, not in a frame', () {
      final cubit = cubitFor(OSMode.android, isHandset: true);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.android);
      expect(cubit.state.showsPhoneFrame, isFalse);
    });

    test('a real iPhone renders full-bleed', () {
      final cubit = cubitFor(OSMode.ios, isHandset: true);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.ios);
      expect(cubit.state.showsPhoneFrame, isFalse);
    });

    // Regression: the frame used to key off orientation, so turning a real
    // phone sideways wrapped the launcher in a fake phone.
    test('orientation does not affect a handset', () {
      final cubit = cubitFor(OSMode.android, isHandset: true);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.ios);
      expect(cubit.state.showsPhoneFrame, isFalse);
    });

    test('previewing mobile on a desktop shows the frame', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.android);
      expect(cubit.state.showsPhoneFrame, isTrue);

      cubit.setMode(OSMode.ios);
      expect(cubit.state.showsPhoneFrame, isTrue);
    });

    test('desktop shells never show the frame', () {
      final cubit = cubitFor(OSMode.macos);
      addTearDown(cubit.close);

      for (final mode in OSMode.values.where((m) => !m.isMobile)) {
        cubit.enterOS(mode);
        expect(cubit.state.showsPhoneFrame, isFalse, reason: '$mode');
      }
    });

    test('a handset browsing a desktop shell shows no frame', () {
      final cubit = cubitFor(OSMode.android, isHandset: true);
      addTearDown(cubit.close);

      cubit.enterOS(OSMode.windows);
      expect(cubit.state.showsPhoneFrame, isFalse);
    });
  });

  group('switching', () {
    test('setMode marks the shell as manually chosen', () {
      final cubit = cubitFor(OSMode.macos);
      addTearDown(cubit.close);

      cubit.setMode(OSMode.windows);

      expect(cubit.state.mode, OSMode.windows);
      expect(cubit.state.isManual, isTrue);
      expect(cubit.state.isNativeShell, isFalse);
    });

    test('selecting the active mode again is a no-op', () {
      final cubit = cubitFor(OSMode.macos);
      addTearDown(cubit.close);

      final before = cubit.state;
      cubit.setMode(OSMode.macos);

      expect(cubit.state, before);
      expect(cubit.state.isManual, isFalse);
    });

    test('detected platform survives switching around', () {
      final cubit = cubitFor(OSMode.linux);
      addTearDown(cubit.close);

      cubit.setMode(OSMode.ios);
      cubit.setMode(OSMode.windows);

      expect(cubit.state.detected, OSMode.linux);
    });

    test('resetToDetected returns to the visitor\'s own platform', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      cubit.setMode(OSMode.macos);
      cubit.resetToDetected();

      expect(cubit.state.mode, OSMode.windows);
      expect(cubit.state.isManual, isFalse);
      expect(cubit.state.isNativeShell, isTrue);
    });

    test('isHandset survives switching', () {
      final cubit = cubitFor(OSMode.ios, isHandset: true);
      addTearDown(cubit.close);

      cubit.setMode(OSMode.windows);
      expect(cubit.state.isHandset, isTrue);
    });

    test('toggleMode cycles through every mode and wraps', () {
      final cubit = cubitFor(OSMode.windows);
      addTearDown(cubit.close);

      final seen = <OSMode>[cubit.state.mode];
      for (var i = 0; i < OSMode.values.length; i++) {
        cubit.toggleMode();
        seen.add(cubit.state.mode);
      }

      expect(seen.toSet(), OSMode.values.toSet());
      expect(seen.last, seen.first, reason: 'A full cycle should wrap around.');
    });
  });

  group('OSMode metadata', () {
    test('every mode has a presentable label and a distinct icon', () {
      final icons = <int>{};
      for (final mode in OSMode.values) {
        expect(mode.label, isNotEmpty);
        expect(mode.label, isNot(equals(mode.name.toUpperCase())));
        icons.add(mode.icon.codePoint);
      }
      expect(
        icons,
        hasLength(OSMode.values.length),
        reason: 'Two modes share an icon, which makes the switcher ambiguous.',
      );
    });

    test('mobile and desktop groupings are correct', () {
      expect(OSMode.android.isMobile, isTrue);
      expect(OSMode.ios.isMobile, isTrue);
      expect(OSMode.windows.isDesktop, isTrue);
    });
  });
}
