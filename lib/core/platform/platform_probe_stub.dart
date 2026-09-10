/// Non-web fallback (unit tests run on the Dart VM, which has no DOM).
///
/// `package:web` pulls in `dart:js_interop`, which does not exist off the web,
/// so the browser probe lives behind a conditional import.
bool isTouchDevice() => false;

double shortestScreenSide() => double.infinity;
