import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class SpotifyWidget extends StatefulWidget {
  const SpotifyWidget({super.key});

  @override
  State<SpotifyWidget> createState() => _SpotifyWidgetState();
}

class _SpotifyWidgetState extends State<SpotifyWidget> {
  bool _isPlaying = true;
  double _progress = 0.3;
  late Timer _timer;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'albumArt': 'https://upload.wikimedia.org/wikipedia/en/e/e6/The_Weeknd_-_Blinding_Lights.png'
    },
    {
      'title': 'Starboy',
      'artist': 'The Weeknd',
      'albumArt': 'https://upload.wikimedia.org/wikipedia/en/3/39/The_Weeknd_-_Starboy.png'
    },
    {
      'title': 'Save Your Tears',
      'artist': 'The Weeknd',
      'albumArt': 'https://upload.wikimedia.org/wikipedia/en/b/b2/The_Weeknd_-_Save_Your_Tears.png'
    }
  ];

  int _currentTrackIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying) {
        setState(() {
          _progress += 0.01;
          if (_progress >= 1.0) {
            _progress = 0.0;
            _nextTrack();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _nextTrack() {
    setState(() {
      _currentTrackIndex = (_currentTrackIndex + 1) % _tracks.length;
      _progress = 0.0;
    });
  }

  void _prevTrack() {
    setState(() {
      _currentTrackIndex = (_currentTrackIndex - 1 + _tracks.length) % _tracks.length;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final track = _tracks[_currentTrackIndex];

    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          // Album Art
          CachedNetworkImage(
            imageUrl: track['albumArt']!,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 32,
              height: 32,
              color: Colors.green.withOpacity(0.3),
              child: const Icon(Icons.music_note, color: Colors.green, size: 20),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.music_note, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 10),
          // Info & Controls
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  track['artist']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Progress Bar
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Play/Pause
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
