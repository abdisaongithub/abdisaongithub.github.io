library;

/// Thin façade over the platform-view iframe helpers.
///
/// `dart:ui_web` and `package:web` do not exist on the Dart VM, so everything
/// that touches them is reached through this conditional import. Importing the
/// web files directly makes any dependent widget untestable.
export 'web_embed_stub.dart' if (dart.library.js_interop) 'web_embed_web.dart';
