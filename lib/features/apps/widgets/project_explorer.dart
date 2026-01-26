import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../file_system/cubit/file_system_cubit.dart';
import '../../file_system/models/file_node.dart';
import '../../virtual_window/cubit/window_manager_cubit.dart';
import '../../virtual_window/window_content.dart';

class ProjectExplorer extends StatefulWidget {
  const ProjectExplorer({super.key});

  @override
  State<ProjectExplorer> createState() => _ProjectExplorerState();
}

class _ProjectExplorerState extends State<ProjectExplorer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileSystemCubit, FileSystemState>(
      builder: (context, state) {
        final currentDir = state.currentDirectory;
        final children = currentDir.children ?? [];

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: state.currentPath == '/'
                  ? null
                  : () => context.read<FileSystemCubit>().cd('..'),
            ),
            title: Text(
              state.currentPath,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: () {
                  // Refresh logic if needed
                },
              ),
            ],
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final node = children[index];
              return _FileIcon(node: node);
            },
          ),
        );
      },
    );
  }
}

class _FileIcon extends StatelessWidget {
  final FileNode node;

  const _FileIcon({required this.node});

  @override
  Widget build(BuildContext context) {
    final isDir = node.isDirectory;
    final icon = isDir ? Icons.folder : _getIconForFile(node.name);
    final color = isDir ? Colors.amber : Colors.blue;

    return InkWell(
      onDoubleTap: () => _handleOpen(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 4),
          Text(
            node.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _handleOpen(BuildContext context) {
    if (node.isDirectory) {
      context.read<FileSystemCubit>().cd(node.name);
    } else {
      // Open file
      if (node.name.endsWith('.md')) {
        context.read<WindowManagerCubit>().openWindow(
              WindowContent(
                type: WindowContentType.markdown,
                title: node.name,
                data: node.content,
              ),
            );
      } else {
        // Fallback for other files
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening ${node.name} (Plain Text)")),
        );
      }
    }
  }

  IconData _getIconForFile(String name) {
    if (name.endsWith('.md')) return Icons.description;
    if (name.endsWith('.json')) return Icons.code;
    return Icons.insert_drive_file;
  }
}
