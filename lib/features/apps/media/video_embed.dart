import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/embed/web_embed.dart';

/// A YouTube video rendered through YouTube's own embed player.
///
/// Same reasoning as the Spotify player: the provider serves and licenses the
/// media, we just composite their iframe.
class VideoEmbed extends StatefulWidget {
  final String videoId;
  final String title;

  const VideoEmbed({super.key, required this.videoId, required this.title});

  @override
  State<VideoEmbed> createState() => _VideoEmbedState();
}

class _VideoEmbedState extends State<VideoEmbed> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'youtube-${widget.videoId}';

    if (isEmbedSupported) {
      registerIframe(
        _viewType,
        'https://www.youtube-nocookie.com/embed/${widget.videoId}'
        '?rel=0&modestbranding=1',
        allow: 'accelerometer; autoplay; clipboard-write; encrypted-media; '
            'gyroscope; picture-in-picture; fullscreen',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: AppRadius.allMd,
        child: isEmbedSupported
            ? buildIframeView(_viewType)
            : Container(
                color: AppColors.surfaceRaised,
                alignment: Alignment.center,
                child: Text(widget.title, style: AppText.bodySm),
              ),
      ),
    );
  }
}
