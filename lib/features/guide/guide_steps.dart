import '../os_mode/os_mode.dart';
import 'guide_cubit.dart';

/// What the guide says inside each shell.
///
/// Steps for controls a shell does not have are dropped at open time by
/// `GuideAnchors.available`, so this can list everything.
List<GuideStep> osGuideSteps(OSMode mode, {required bool isHandset}) {
  final tap = isHandset ? 'Tap' : 'Click';

  return [
    GuideStep(
      target: GuideTarget.apps,
      title: 'Open an app',
      body: switch (mode) {
        OSMode.windows => '$tap a desktop icon — About Me for my CV, Projects '
            'for my work. Windows drag, resize and maximise.',
        OSMode.macos => 'Everything lives in the dock. $tap About Me or '
            'Projects; windows drag, resize and minimise to the dock.',
        OSMode.linux => 'The launcher on the left opens Projects, Files and '
            'the Terminal. Windows drag and resize.',
        OSMode.android => '$tap About for my CV, Projects for my work, or '
            'Contact to reach me.',
        OSMode.ios => '$tap Projects for my work, Mail to reach me, or GitHub '
            'for my latest repositories.',
      },
    ),
    const GuideStep(
      target: GuideTarget.terminal,
      title: 'Prefer a keyboard?',
      body: 'Open the terminal and try help, ls, cd documents and '
          'cat welcome.txt. Type exit to close it.',
    ),
    const GuideStep(
      target: GuideTarget.switcher,
      title: 'Try another OS',
      body: 'The same portfolio runs as Windows, macOS, Ubuntu, Android and '
          'iOS — yours is marked. "Show me around" in this menu brings this '
          'guide back.',
    ),
    if (!isHandset)
      const GuideStep(
        target: null,
        title: 'Jump anywhere',
        body: 'Press Ctrl K (⌘K on a Mac) to open any app, switch OS or copy '
            'my email without hunting for it.',
      ),
    const GuideStep(
      target: GuideTarget.portfolio,
      title: 'Back to the portfolio',
      body: 'Projects, experience and contact details are one click away. '
          'The ? button next to it reopens this guide.',
    ),
  ];
}
