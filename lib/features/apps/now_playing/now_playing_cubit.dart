import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Track extends Equatable {
  final String title;
  final String artist;
  final String albumArt;

  const Track({
    required this.title,
    required this.artist,
    required this.albumArt,
  });

  @override
  List<Object> get props => [title, artist, albumArt];
}

class NowPlayingState extends Equatable {
  final List<Track> tracks;
  final int index;
  final bool isPlaying;

  /// 0.0 - 1.0 through the current track.
  final double progress;

  const NowPlayingState({
    required this.tracks,
    this.index = 0,
    this.isPlaying = true,
    this.progress = 0.3,
  });

  Track get track => tracks[index];

  NowPlayingState copyWith({int? index, bool? isPlaying, double? progress}) {
    return NowPlayingState(
      tracks: tracks,
      index: index ?? this.index,
      isPlaying: isPlaying ?? this.isPlaying,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object> get props => [tracks, index, isPlaying, progress];
}

/// Mock playback shared by every surface that shows "now playing".
///
/// Each Spotify widget used to own its own [Timer] and track index, so the
/// macOS menu bar and the Windows taskbar drifted out of sync and every extra
/// mount added another ticking timer.
class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit({List<Track>? tracks, bool autoStart = true})
      : super(NowPlayingState(tracks: tracks ?? _defaultTracks)) {
    if (autoStart) _start();
  }

  static const Duration _tick = Duration(seconds: 1);

  /// A track advances every ~100 ticks.
  static const double _progressPerTick = 0.01;

  Timer? _timer;

  static const List<Track> _defaultTracks = [
    Track(
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/e/e6/The_Weeknd_-_Blinding_Lights.png',
    ),
    Track(
      title: 'Starboy',
      artist: 'The Weeknd',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/3/39/The_Weeknd_-_Starboy.png',
    ),
    Track(
      title: 'Save Your Tears',
      artist: 'The Weeknd',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/b/b2/The_Weeknd_-_Save_Your_Tears.png',
    ),
  ];

  void _start() {
    _timer = Timer.periodic(_tick, (_) {
      if (!state.isPlaying) return;

      final next = state.progress + _progressPerTick;
      if (next >= 1.0) {
        nextTrack();
      } else {
        emit(state.copyWith(progress: next));
      }
    });
  }

  void togglePlay() => emit(state.copyWith(isPlaying: !state.isPlaying));

  void nextTrack() {
    emit(
      state.copyWith(
        index: (state.index + 1) % state.tracks.length,
        progress: 0,
      ),
    );
  }

  void previousTrack() {
    emit(
      state.copyWith(
        index: (state.index - 1 + state.tracks.length) % state.tracks.length,
        progress: 0,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
