import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/embed/web_embed.dart';

/// Real Spotify playback via Spotify's official embed player.
///
/// We cannot host "Blinding Lights" ourselves — it is a commercial recording,
/// and rehosting it would be infringement. Spotify's embed is the sanctioned
/// route: it needs no API key, and the audio is served and licensed by Spotify.
///
/// Visitors who are logged into Spotify Premium hear the full track; everyone
/// else hears the 30-second preview. That split is Spotify's rule, not ours.
class SpotifyPlayer extends StatefulWidget {
  /// Spotify track id. Defaults to The Weeknd — Blinding Lights.
  final String trackId;

  /// Compact renders Spotify's slim 80px player; otherwise the 152px card.
  final bool compact;

  const SpotifyPlayer({
    super.key,
    this.trackId = blindingLights,
    this.compact = false,
  });

  static const String blindingLights = '0VjIjW4GlUZAMYd2vXMi3b';

  @override
  State<SpotifyPlayer> createState() => _SpotifyPlayerState();
}

class _SpotifyPlayerState extends State<SpotifyPlayer> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'spotify-${widget.trackId}-${widget.compact}';

    if (isEmbedSupported) {
      registerIframe(
        _viewType,
        'https://open.spotify.com/embed/track/${widget.trackId}'
        '?utm_source=portfolio&theme=0',
        allow: 'autoplay; clipboard-write; encrypted-media; fullscreen; '
            'picture-in-picture',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 80.0 : 152.0;

    if (!isEmbedSupported) {
      return _SpotifyFallback(height: height);
    }

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: AppRadius.allMd,
        child: buildIframeView(_viewType),
      ),
    );
  }
}

/// Shown when platform views are unavailable (unit tests, non-web builds).
class _SpotifyFallback extends StatelessWidget {
  final double height;

  const _SpotifyFallback({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.music_note, color: AppColors.spotify, size: 18),
          SizedBox(width: AppSpacing.sm),
          Text('Spotify player', style: AppText.bodySm),
        ],
      ),
    );
  }
}
