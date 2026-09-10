import 'package:web/web.dart' as web;

/// Touch points reported by a real multi-touch screen. Desktop browsers report
/// 0; a trackpad does not count.
bool isTouchDevice() => web.window.navigator.maxTouchPoints > 1;

double shortestScreenSide() {
  final screen = web.window.screen;
  return (screen.width < screen.height ? screen.width : screen.height)
      .toDouble();
}
