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
    // Exhaustive on purpose: adding a WindowContentType now fails the analyzer
    // instead of silently rendering "Unknown Content" at runtime.
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
          images: content.data as List<String>? ?? const [],
          title: content.title,
        );
      case WindowContentType.projectDetail:
        return const ProjectExplorer();
      case WindowContentType.code:
        return const CodeEditorApp();
      case WindowContentType.settings:
        return const SettingsApp();
      case WindowContentType.experience:
      case WindowContentType.profile:
      case WindowContentType.skills:
        return const ExperienceApp();
      case WindowContentType.contact:
      case WindowContentType.webBrowser:
        return _Placeholder(title: content.title);
    }
  }
}

class _Placeholder extends StatelessWidget {
  final String title;

  const _Placeholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 40, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              '$title is not available yet.',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
