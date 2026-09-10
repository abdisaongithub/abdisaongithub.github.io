import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/apps/now_playing/now_playing_cubit.dart';
import 'package:flutter_portfolio_app/features/apps/now_playing/now_playing_widget.dart';

/// Chrome heights the now-playing readout has to live inside.
const double _kMacMenuBar = 24;
const double _kGnomeTopBar = 28;
const double _kWindowsTaskbar = 48;
const double _kMobileStatusBar = 24;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child, {double? height}) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          // autoStart: false keeps the periodic timer out of widget tests.
          create: (_) => NowPlayingCubit(autoStart: false),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(height: height, child: child),
          ),
        ),
      ),
    );
  }

  group('sizing', () {
    // Regression: a fixed 250x44 card was dropped straight into the macOS
    // menu bar (24px) and the GNOME top bar (28px) and overflowed every frame.
    testWidgets('compact fits inside a macOS menu bar', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NowPlayingWidget(variant: NowPlayingVariant.compact),
          height: _kMacMenuBar,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      final size = tester.getSize(find.byType(NowPlayingWidget));
      expect(size.height, lessThanOrEqualTo(_kMacMenuBar));
    });

    testWidgets('compact fits inside a GNOME top bar', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NowPlayingWidget(variant: NowPlayingVariant.compact),
          height: _kGnomeTopBar,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(NowPlayingWidget)).height,
        lessThanOrEqualTo(_kGnomeTopBar),
      );
    });

    testWidgets('full card fits inside a Windows taskbar', (tester) async {
      await tester.pumpWidget(
        wrap(const NowPlayingWidget(), height: _kWindowsTaskbar),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(NowPlayingWidget)).height,
        lessThanOrEqualTo(_kWindowsTaskbar),
      );
    });

    testWidgets('indicator fits inside a phone status bar', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NowPlayingWidget(variant: NowPlayingVariant.indicator),
          height: _kMobileStatusBar,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(NowPlayingWidget)).height,
        lessThanOrEqualTo(_kMobileStatusBar),
      );
    });

    testWidgets('a long track title ellipsises rather than overflowing', (
      tester,
    ) async {
      const longTitle =
          'An Extremely Long Track Title That Would Never Fit In A Menu Bar';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create: (_) => NowPlayingCubit(
                autoStart: false,
                tracks: const [
                  Track(title: longTitle, artist: 'Someone', albumArt: ''),
                ],
              ),
              child: const Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: _kMacMenuBar,
                  child: NowPlayingWidget(
                    variant: NowPlayingVariant.compact,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('shared playback state', () {
    test('starts on the first track, playing', () {
      final cubit = NowPlayingCubit(autoStart: false);
      addTearDown(cubit.close);

      expect(cubit.state.index, 0);
      expect(cubit.state.isPlaying, isTrue);
    });

    test('next and previous wrap around', () {
      final cubit = NowPlayingCubit(autoStart: false);
      addTearDown(cubit.close);

      final count = cubit.state.tracks.length;
      for (var i = 0; i < count; i++) {
        cubit.nextTrack();
      }
      expect(cubit.state.index, 0);

      cubit.previousTrack();
      expect(cubit.state.index, count - 1);
    });

    test('changing track resets progress', () {
      final cubit = NowPlayingCubit(autoStart: false);
      addTearDown(cubit.close);

      expect(cubit.state.progress, greaterThan(0));
      cubit.nextTrack();
      expect(cubit.state.progress, 0);
    });

    test('togglePlay flips playback', () {
      final cubit = NowPlayingCubit(autoStart: false);
      addTearDown(cubit.close);

      cubit.togglePlay();
      expect(cubit.state.isPlaying, isFalse);
      cubit.togglePlay();
      expect(cubit.state.isPlaying, isTrue);
    });

    // Each Spotify widget used to own its own timer and index, so the macOS
    // menu bar and Windows taskbar drifted apart.
    testWidgets('every surface renders the same track', (tester) async {
      final cubit = NowPlayingCubit(autoStart: false);
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: const Column(
                children: [
                  SizedBox(height: 48, child: NowPlayingWidget()),
                  SizedBox(
                    height: 24,
                    child: NowPlayingWidget(
                      variant: NowPlayingVariant.compact,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      cubit.nextTrack();
      // Bloc delivers state on an async stream: the first pump schedules the
      // rebuild, the second renders it.
      await tester.pump();
      await tester.pump();

      final title = cubit.state.track.title;
      expect(find.text(title), findsNWidgets(2));
    });
  });
}
