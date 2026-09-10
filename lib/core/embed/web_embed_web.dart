import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

bool get isEmbedSupported => true;

final Set<String> _registered = <String>{};

/// Registers an `<iframe>` as a platform view Flutter can composite.
///
/// This is how a real Spotify player and real video embeds work inside a
/// Flutter web app — the provider's own player runs in the iframe, so playback
/// is licensed by them rather than us rehosting copyrighted media.
void registerIframe(String viewType, String src, {String? allow}) {
  if (_registered.contains(viewType)) return;
  _registered.add(viewType);

  ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
    final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
      ..src = src
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..setAttribute('loading', 'lazy')
      ..setAttribute('frameborder', '0');

    if (allow != null) iframe.setAttribute('allow', allow);
    iframe.setAttribute(
      'referrerpolicy',
      'strict-origin-when-cross-origin',
    );
    return iframe;
  });
}

Widget buildIframeView(String viewType) => HtmlElementView(viewType: viewType);
