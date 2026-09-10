import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum WindowContentType {
  portfolio,
  profile,
  projectDetail,
  files,
  skills,
  experience,
  contact,
  webBrowser,
  terminal,
  settings,
  markdown,
  gallery,
}

extension WindowContentTypeIcon on WindowContentType {
  /// Icon used to represent an open window in taskbars and docks.
  IconData get icon {
    switch (this) {
      case WindowContentType.portfolio:
        return Icons.auto_awesome_mosaic_outlined;
      case WindowContentType.profile:
        return Icons.person_outline;
      case WindowContentType.projectDetail:
        return Icons.grid_view_rounded;
      case WindowContentType.files:
        return Icons.folder_open_outlined;
      case WindowContentType.skills:
        return Icons.bolt_outlined;
      case WindowContentType.experience:
        return Icons.badge_outlined;
      case WindowContentType.contact:
        return Icons.alternate_email;
      case WindowContentType.webBrowser:
        return Icons.public;
      case WindowContentType.terminal:
        return Icons.terminal;
      case WindowContentType.settings:
        return Icons.settings_outlined;
      case WindowContentType.markdown:
        return Icons.description_outlined;
      case WindowContentType.gallery:
        return Icons.photo_library_outlined;
    }
  }
}

class WindowContent extends Equatable {
  final WindowContentType type;
  final String title;
  final Object? data; // e.g. Project ID

  const WindowContent({required this.type, required this.title, this.data});

  @override
  List<Object?> get props => [type, title, data];
}
