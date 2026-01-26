import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../virtual_window/cubit/window_manager_cubit.dart';
import '../virtual_window/window_content.dart';
import 'app_enums.dart';

class AppLauncherService {
  static Future<void> launch(BuildContext context, AppType app) async {
    switch (app) {
      case AppType.cv:
        context.read<WindowManagerCubit>().openWindow(
              const WindowContent(
                title: 'Curriculum Vitae',
                type: WindowContentType.experience,
              ),
            );
        break;

      case AppType.email:
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path:
              'abdisa.tsegaye@gmail.com', // Update with actual email if known, using placeholder from history context or request
          query: 'subject=Hello from Portfolio',
        );
        await _launchUrl(emailLaunchUri);
        break;

      case AppType.phone:
        final Uri telLaunchUri = Uri(
          scheme: 'tel',
          path: '+251911364379', // Placeholder or real number if known
        );
        await _launchUrl(telLaunchUri);
        break;

      case AppType.github:
        await _launchUrl(Uri.parse('https://github.com/abdisaongithub'));
        break;

      case AppType.linkedin:
        // Placeholder, user can update later
        await _launchUrl(Uri.parse('https://linkedin.com/in/abdisa-tsegaye'));
        break;

      case AppType.camera:
        // "Clicking camera either starts a google meet meeting..."
        await _launchUrl(Uri.parse('https://meet.google.com/new'));
        // Alternatively, open a virtual window with a "Connect" CTA
        // context.read<WindowManagerCubit>().openWindow(
        //   const WindowContent(title: 'Camera', type: WindowContentType.camera),
        // );
        break;

      case AppType.projects:
        context.read<WindowManagerCubit>().openWindow(
              const WindowContent(
                title: 'Projects',
                type: WindowContentType.projectDetail,
                data: 'All', // Show all projects
              ),
            );
        break;

      case AppType.terminal:
        context.read<WindowManagerCubit>().openWindow(
              const WindowContent(
                title: 'Terminal',
                type: WindowContentType.terminal,
              ),
            );
        break;

      case AppType.browser:
        // Simple fallback for now, or open a mock browser window
        await _launchUrl(Uri.parse('https://google.com')); // Placeholder
        break;

      case AppType.code:
        context.read<WindowManagerCubit>().openWindow(
              const WindowContent(
                title: 'Visual Studio Code',
                type: WindowContentType.code,
              ),
            );
        break;

      // TODO: Implement other apps if needed
      default:
        debugPrint('App $app not implemented yet');
        break;
    }
  }

  static Future<void> _launchUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $uri');
    }
  }
}
