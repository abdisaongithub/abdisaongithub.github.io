import 'package:flutter/material.dart';
import '../apps/widgets/markdown_viewer_app.dart';
import 'window_content.dart';

class WindowContentBuilder {
  static Widget build(WindowContent content) {
    switch (content.type) {
      case WindowContentType.markdown:
        return MarkdownViewerApp(
          content: content.data as String? ?? '',
          title: content.title,
        );
      case WindowContentType.profile:
        return const Center(child: Text("Profile App Placeholder"));
      case WindowContentType.projectDetail:
        return const Center(child: Text("Project Detail Placeholder"));
      // Add other cases...
      default:
        return Center(child: Text("Unknown Content: ${content.type}"));
    }
  }
}
