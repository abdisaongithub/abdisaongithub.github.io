import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/profile.dart';
import '../virtual_window/cubit/window_manager_cubit.dart';
import '../virtual_window/window_content.dart';
import 'app_enums.dart';

class AppLauncherService {
  static Future<void> launch(BuildContext context, AppType app) async {
    final windows = context.read<WindowManagerCubit>();

    switch (app) {
      case AppType.portfolio:
        windows.openWindow(
          const WindowContent(
            title: 'Portfolio — Abdisa Tsegaye',
            type: WindowContentType.portfolio,
          ),
        );

      case AppType.cv:
        windows.openWindow(
          const WindowContent(
            title: 'Curriculum Vitae',
            type: WindowContentType.experience,
          ),
        );

      case AppType.projects:
        windows.openWindow(
          const WindowContent(
            title: 'Projects',
            type: WindowContentType.projectDetail,
            data: 'All', // Show all projects
          ),
        );

      case AppType.files:
        windows.openWindow(
          const WindowContent(
            title: 'Files',
            type: WindowContentType.files,
          ),
        );

      case AppType.terminal:
        windows.openWindow(
          const WindowContent(
            title: 'Terminal',
            type: WindowContentType.terminal,
          ),
        );

      // Every desktop dock and mobile grid already pointed at this, but the
      // case was missing, so Settings could never actually be opened.
      case AppType.settings:
        windows.openWindow(
          const WindowContent(
            title: 'Settings',
            type: WindowContentType.settings,
          ),
        );

      case AppType.email:
        await _launchUrl(
          Uri(
            scheme: 'mailto',
            path: Profile.email,
            query: 'subject=Hello from your portfolio',
          ),
        );

      case AppType.phone:
        await _launchUrl(Uri(scheme: 'tel', path: Profile.phone));

      case AppType.github:
        await _launchUrl(Uri.parse(Profile.githubUrl));

      case AppType.linkedin:
        await _launchUrl(Uri.parse(Profile.linkedinUrl));

      case AppType.camera:
        await _launchUrl(Uri.parse('https://meet.google.com/new'));

      case AppType.browser:
        await _launchUrl(Uri.parse(Profile.githubUrl));

      case AppType.unknown:
        debugPrint('App $app not implemented yet');
    }
  }

  static Future<void> _launchUrl(Uri uri) async {
    try {
      // On web, LaunchMode.externalApplication is unreliable and gets caught
      // by popup blockers. platformDefault plus an explicit _blank window name
      // is what actually opens a new tab.
      final launched = await launchUrl(uri, webOnlyWindowName: '_blank');
      if (!launched) debugPrint('Could not launch $uri');
    } catch (e) {
      // canLaunchUrl is unreliable on web for mailto/tel, so we attempt the
      // launch directly and only report a genuine failure.
      debugPrint('Could not launch $uri: $e');
    }
  }
}
