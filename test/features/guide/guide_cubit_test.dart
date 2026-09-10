import 'package:flutter_portfolio_app/features/guide/guide_cubit.dart';
import 'package:flutter_portfolio_app/features/guide/guide_steps.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _steps = [
  GuideStep(target: GuideTarget.apps, title: 'Apps', body: 'Open one.'),
  GuideStep(target: GuideTarget.terminal, title: 'Terminal', body: 'Type.'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('walking through the steps', () {
    test('next moves forward and closes after the last step', () async {
      final cubit = GuideCubit()..open(_steps);
      expect(cubit.state.current, _steps[0]);
      expect(cubit.state.isFirst, isTrue);

      cubit.next();
      expect(cubit.state.current, _steps[1]);
      expect(cubit.state.isLast, isTrue);

      cubit.next();
      expect(cubit.state.isOpen, isFalse);
      expect(cubit.state.osGuideSeen, isTrue);
      await cubit.close();
    });

    test('back stops at the first step', () async {
      final cubit = GuideCubit()
        ..open(_steps)
        ..next()
        ..back()
        ..back();
      expect(cubit.state.index, 0);
      expect(cubit.state.isOpen, isTrue);
      await cubit.close();
    });

    test('dismiss works from any step and is a no-op when closed', () async {
      final cubit = GuideCubit()
        ..open(_steps)
        ..next()
        ..dismiss();
      expect(cubit.state.isOpen, isFalse);

      cubit
        ..dismiss()
        ..next()
        ..back();
      expect(cubit.state.isOpen, isFalse);
      await cubit.close();
    });

    test('opening with no steps does nothing', () async {
      final cubit = GuideCubit()..open(const []);
      expect(cubit.state.isOpen, isFalse);
      expect(cubit.state.osGuideSeen, isFalse);
      await cubit.close();
    });
  });

  group('first visit', () {
    test('shows once, then never again uninvited', () async {
      final cubit = GuideCubit();

      await cubit.showOSGuideOnce(() => _steps);
      expect(cubit.state.isOpen, isTrue);

      cubit.dismiss();
      await cubit.showOSGuideOnce(() => _steps);
      expect(cubit.state.isOpen, isFalse);
      await cubit.close();
    });

    test('is remembered for returning visitors', () async {
      final first = GuideCubit();
      await first.showOSGuideOnce(() => _steps);
      await Future<void>.delayed(Duration.zero);
      await first.close();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(GuideCubit.seenKey), isTrue);

      final returning = GuideCubit();
      await returning.showOSGuideOnce(() => _steps);
      expect(returning.state.isOpen, isFalse);
      expect(returning.state.osGuideSeen, isTrue);
      await returning.close();
    });

    test('can always be reopened on demand', () async {
      SharedPreferences.setMockInitialValues({GuideCubit.seenKey: true});
      final cubit = GuideCubit();
      await cubit.showOSGuideOnce(() => _steps);
      expect(cubit.state.isOpen, isFalse);

      cubit.open(_steps);
      expect(cubit.state.isOpen, isTrue);
      await cubit.close();
    });

    test('blocked storage still shows the guide', () async {
      final cubit = GuideCubit(
        preferences: () async => throw Exception('storage blocked'),
      );
      await cubit.showOSGuideOnce(() => _steps);
      expect(cubit.state.isOpen, isTrue);
      await cubit.close();
    });

    test('steps are resolved after the preference loads', () async {
      final cubit = GuideCubit();
      var resolved = false;
      final pending = cubit.showOSGuideOnce(() {
        resolved = true;
        return _steps;
      });
      expect(resolved, isFalse);
      await pending;
      expect(resolved, isTrue);
      await cubit.close();
    });
  });

  group('osGuideSteps', () {
    test('every shell points at apps, the terminal and the switcher', () {
      for (final mode in OSMode.values) {
        for (final isHandset in [false, true]) {
          final targets =
              osGuideSteps(mode, isHandset: isHandset).map((s) => s.target);
          expect(
            targets,
            containsAll([
              GuideTarget.apps,
              GuideTarget.terminal,
              GuideTarget.switcher,
            ]),
            reason: '$mode, handset: $isHandset',
          );
        }
      }
    });

    test('the keyboard shortcut tip is only for devices with a keyboard', () {
      bool hasShortcutTip(bool isHandset) =>
          osGuideSteps(OSMode.windows, isHandset: isHandset)
              .any((s) => s.target == null);

      expect(hasShortcutTip(false), isTrue);
      expect(hasShortcutTip(true), isFalse);
    });

    test('handsets are told to tap, not click', () {
      final apps = osGuideSteps(OSMode.android, isHandset: true).first;
      expect(apps.body, contains('Tap'));
      expect(apps.body, isNot(contains('Click')));
    });

    test('terminal tip only names commands the terminal understands', () {
      final terminal = osGuideSteps(OSMode.linux, isHandset: false)
          .firstWhere((s) => s.target == GuideTarget.terminal);
      for (final command in ['help', 'ls', 'cd documents', 'cat', 'exit']) {
        expect(terminal.body, contains(command));
      }
    });
  });
}
