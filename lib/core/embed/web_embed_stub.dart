import 'package:flutter/material.dart';

/// Non-web fallback. Unit tests run on the Dart VM, which has no DOM, so the
/// real iframe implementation lives behind a conditional import.
bool get isEmbedSupported => false;

void registerIframe(String viewType, String src, {String? allow}) {}

Widget buildIframeView(String viewType) => const SizedBox.shrink();
