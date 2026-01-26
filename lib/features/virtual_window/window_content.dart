import 'package:equatable/equatable.dart';

enum WindowContentType {
  profile,
  projectDetail,
  skills,
  experience,
  contact,
  webBrowser, // For external links if we want to fake a browser
  markdown,
}

class WindowContent extends Equatable {
  final WindowContentType type;
  final String title;
  final Object? data; // e.g. Project ID

  const WindowContent({required this.type, required this.title, this.data});

  @override
  List<Object?> get props => [type, title, data];
}
