import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/virtual_window/window_content.dart';

void main() {
  // Guards the taskbar/dock: every window type must render an icon, otherwise
  // an open window shows up as a blank square.
  test('every WindowContentType maps to an icon', () {
    for (final type in WindowContentType.values) {
      expect(type.icon, isNotNull, reason: 'Missing icon for $type');
    }
  });
}
