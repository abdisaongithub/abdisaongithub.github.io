import 'package:flutter/material.dart';

class CodeEditorApp extends StatefulWidget {
  const CodeEditorApp({super.key});

  @override
  State<CodeEditorApp> createState() => _CodeEditorAppState();
}

class _CodeEditorAppState extends State<CodeEditorApp> {
  // Simple "file system" for the editor
  final Map<String, String> _files = {
    'main.dart': '''
void main() {
  print("Welcome to Abdisa's Portfolio!");
  runApp(PortfolioApp());
}
''',
    'experience.dart': '''
class Experience {
  final String role = "Flutter Developer";
  final int years = 3;
  
  void buildAwesomeApps() {
    // Implementing cool features...
  }
}
''',
    'skills.json': '''
{
  "languages": ["Dart", "Python", "JavaScript"],
  "frameworks": ["Flutter", "React", "Django"],
  "tools": ["Git", "Firebase", "Figma"]
}
'''
  };

  String _selectedFile = 'main.dart';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E), // VS Code Dark Theme background
      child: Row(
        children: [
          // Sidebar (Explorer)
          Container(
            width: 200,
            color: const Color(0xFF252526),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'EXPLORER',
                    style: TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: _files.keys.map((fileName) {
                      final isSelected = fileName == _selectedFile;
                      return InkWell(
                        onTap: () => setState(() => _selectedFile = fileName),
                        child: Container(
                          color: isSelected ? const Color(0xFF37373D) : null,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                _getIconForFile(fileName),
                                size: 16,
                                color: _getColorForFile(fileName),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                fileName,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFFCCCCCC),
                                  fontFamily: 'Segoe UI',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main Editor Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs
                Container(
                  height: 35,
                  color: const Color(0xFF1E1E1E),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: const Color(0xFF1E1E1E), // Active tab
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Icon(_getIconForFile(_selectedFile),
                                size: 14,
                                color: _getColorForFile(_selectedFile)),
                            const SizedBox(width: 8),
                            Text(
                              _selectedFile,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Code Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Text(
                        _files[_selectedFile]!,
                        style: const TextStyle(
                          color: Color(0xFFD4D4D4),
                          fontFamily: 'Courier New', // Monospace
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForFile(String name) {
    if (name.endsWith('.dart')) return Icons.code;
    if (name.endsWith('.json')) return Icons.data_object;
    return Icons.insert_drive_file;
  }

  Color _getColorForFile(String name) {
    if (name.endsWith('.dart')) return Colors.blueAccent;
    if (name.endsWith('.json')) return Colors.yellow;
    return Colors.grey;
  }
}
