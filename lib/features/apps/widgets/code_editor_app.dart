import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import '../../file_system/cubit/file_system_cubit.dart';
import '../../file_system/models/file_node.dart';

class CodeEditorApp extends StatefulWidget {
  const CodeEditorApp({super.key});

  @override
  State<CodeEditorApp> createState() => _CodeEditorAppState();
}

class _CodeEditorAppState extends State<CodeEditorApp> {
  FileNode? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileSystemCubit, FileSystemState>(
      builder: (context, state) {
        final allFiles = _getAllFiles(state.root);
        if (_selectedFile == null && allFiles.isNotEmpty) {
          _selectedFile = allFiles.first;
        }

        return Container(
          color: const Color(0xFF1E1E1E),
          child: Row(
            children: [
              // Sidebar
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
                        children: allFiles.map((file) {
                          final isSelected = file.id == _selectedFile?.id;
                          return InkWell(
                            onTap: () => setState(() => _selectedFile = file),
                            child: Container(
                              color: isSelected ? const Color(0xFF37373D) : null,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    _getIconForFile(file.name),
                                    size: 16,
                                    color: _getColorForFile(file.name),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      file.name,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFFCCCCCC),
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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

              // Editor
              Expanded(
                child: Column(
                  children: [
                    if (_selectedFile != null)
                      Container(
                        height: 35,
                        color: const Color(0xFF1E1E1E),
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              color: const Color(0xFF1E1E1E),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Icon(_getIconForFile(_selectedFile!.name),
                                      size: 14,
                                      color:
                                          _getColorForFile(_selectedFile!.name)),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedFile!.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFF1E1E1E),
                        child: _selectedFile != null
                            ? SingleChildScrollView(
                                child: HighlightView(
                                  _selectedFile!.content ?? '',
                                  language: _getLanguageForFile(_selectedFile!.name),
                                  theme: vs2015Theme,
                                  padding: const EdgeInsets.all(16),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Courier New',
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Select a file to view code",
                                  style: TextStyle(color: Colors.grey),
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
      },
    );
  }

  List<FileNode> _getAllFiles(FileNode node) {
    List<FileNode> files = [];
    if (!node.isDirectory) {
      files.add(node);
    } else if (node.children != null) {
      for (var child in node.children!) {
        files.addAll(_getAllFiles(child));
      }
    }
    return files;
  }

  IconData _getIconForFile(String name) {
    if (name.endsWith('.dart')) return Icons.code;
    if (name.endsWith('.json')) return Icons.data_object;
    if (name.endsWith('.md')) return Icons.description;
    return Icons.insert_drive_file;
  }

  Color _getColorForFile(String name) {
    if (name.endsWith('.dart')) return Colors.blueAccent;
    if (name.endsWith('.json')) return Colors.yellow;
    if (name.endsWith('.md')) return Colors.blue;
    return Colors.grey;
  }

  String _getLanguageForFile(String name) {
    if (name.endsWith('.dart')) return 'dart';
    if (name.endsWith('.json')) return 'json';
    if (name.endsWith('.md')) return 'markdown';
    return 'plaintext';
  }
}
