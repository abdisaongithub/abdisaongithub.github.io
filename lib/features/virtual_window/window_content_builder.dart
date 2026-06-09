import 'package:flutter/material.dart';
import '../apps/widgets/markdown_viewer_app.dart';
import '../apps/widgets/terminal_app.dart';
import '../apps/widgets/gallery_app.dart';
import '../apps/widgets/project_explorer.dart';
import '../apps/widgets/code_editor_app.dart';
import '../apps/widgets/settings_app.dart';
import '../apps/widgets/experience_app.dart';
import 'window_content.dart';

class WindowContentBuilder extends StatelessWidget {
  final WindowContent content;

  const WindowContentBuilder({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case WindowContentType.markdown:
        return MarkdownViewerApp(
          content: content.data as String? ?? '',
          title: content.title,
        );
      case WindowContentType.terminal:
        return const TerminalApp();
      case WindowContentType.gallery:
        return GalleryApp(
          images: content.data as List<String>? ?? [],
          title: content.title,
        );
      case WindowContentType.projectDetail:
        return const ProjectExplorer();
      case WindowContentType.code:
        return const CodeEditorApp();
      case WindowContentType.settings:
        return const SettingsApp();
      case WindowContentType.experience:
        return const ExperienceApp();
      case WindowContentType.profile:
        return const Center(child: Text("Profile App Placeholder"));
      default:
        return Center(child: Text("Unknown Content: ${content.type}"));
    }
  }

  // Still keeping the static method for convenience if needed elsewhere
  static Widget buildContent(WindowContent content) {
    return WindowContentBuilder(content: content);
  }
}
