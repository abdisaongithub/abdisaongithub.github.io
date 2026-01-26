import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownViewerApp extends StatelessWidget {
  final String content;
  final String title;

  const MarkdownViewerApp({
    super.key,
    required this.content,
    this.title = 'Document Viewer',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // TODO: Implement copy to clipboard
            },
          ),
        ],
      ),
      body: Markdown(
        data: content,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          p: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
