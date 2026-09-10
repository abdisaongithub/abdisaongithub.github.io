import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'now_playing_cubit.dart';

/// How much room the host chrome has for a "now playing" readout.
enum NowPlayingVariant {
  /// Full card with artwork, both lines of text, a progress bar and transport
  /// controls. Needs ~44px of height — a Windows-style taskbar.
  full,

  /// Single line sized to sit inside a menu bar (macOS is 24px, GNOME 28px).
  compact,

  /// Just an animated glyph, for phone status bars.
  indicator,
}

class NowPlayingWidget extends StatelessWidget {
  final NowPlayingVariant variant;

  /// Tint for [NowPlayingVariant.compact] and [NowPlayingVariant.indicator],
  /// which sit directly on the host chrome.
  final Color foreground;

  const NowPlayingWidget({
    super.key,
    this.variant = NowPlayingVariant.full,
    this.foreground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        switch (variant) {
          case NowPlayingVariant.full:
            return _FullCard(state: state);
          case NowPlayingVariant.compact:
            return _CompactBar(state: state, foreground: foreground);
          case NowPlayingVariant.indicator:
            return _Indicator(state: state, foreground: foreground);
        }
      },
    );
  }
}

class _FullCard extends StatelessWidget {
  final NowPlayingState state;

  const _FullCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NowPlayingCubit>();
    final track = state.track;

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(url: track.albumArt, size: 30),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  track.artist,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1DB954),
                    ),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          _ControlButton(
            icon: Icons.skip_previous,
            tooltip: 'Previous',
            onTap: cubit.previousTrack,
          ),
          _ControlButton(
            icon: state.isPlaying ? Icons.pause : Icons.play_arrow,
            tooltip: state.isPlaying ? 'Pause' : 'Play',
            onTap: cubit.togglePlay,
          ),
          _ControlButton(
            icon: Icons.skip_next,
            tooltip: 'Next',
            onTap: cubit.nextTrack,
          ),
        ],
      ),
    );
  }
}

/// Menu-bar sized. Everything here is deliberately small enough to fit inside
/// a 24px macOS menu bar without overflowing.
class _CompactBar extends StatelessWidget {
  final NowPlayingState state;
  final Color foreground;

  const _CompactBar({required this.state, required this.foreground});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NowPlayingCubit>();
    final track = state.track;

    return Tooltip(
      message: '${track.title} — ${track.artist}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: cubit.togglePlay,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                state.isPlaying ? Icons.graphic_eq : Icons.pause,
                size: 13,
                color: const Color(0xFF1DB954),
              ),
              const SizedBox(width: 5),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 130),
                child: Text(
                  track.title,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 12,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Phone status bars only have room for a glyph.
class _Indicator extends StatelessWidget {
  final NowPlayingState state;
  final Color foreground;

  const _Indicator({required this.state, required this.foreground});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${state.track.title} — ${state.track.artist}',
      child: Icon(
        state.isPlaying ? Icons.music_note : Icons.pause,
        size: 14,
        color: foreground,
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  final String url;
  final double size;

  const _Artwork({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: const Color(0xFF1DB954).withValues(alpha: 0.3),
      child: Icon(
        Icons.music_note,
        color: const Color(0xFF1DB954),
        size: size * 0.6,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(icon, color: Colors.white, size: 15),
          ),
        ),
      ),
    );
  }
}
