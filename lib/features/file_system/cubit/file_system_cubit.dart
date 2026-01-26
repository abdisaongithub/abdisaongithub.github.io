import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../models/file_node.dart';

part 'file_system_state.dart';

class FileSystemCubit extends Cubit<FileSystemState> {
  FileSystemCubit() : super(FileSystemState(root: FileNode.root())) {
    _initializeDefaultStructure();
  }

  final _uuid = const Uuid();

  void _initializeDefaultStructure() {
    // Create default /home/abdisa structure
    final projects = FileNode(
      id: _uuid.v4(),
      name: 'projects',
      type: FileType.directory,
      children: [],
    );

    final documents = FileNode(
      id: _uuid.v4(),
      name: 'documents',
      type: FileType.directory,
      children: [
        FileNode(
          id: _uuid.v4(),
          name: 'welcome.txt',
          type: FileType.file,
          content: 'Welcome to Abdisa OS! Explore the file system.',
        ),
      ],
    );

    final userHome = FileNode(
      id: _uuid.v4(),
      name: 'abdisa',
      type: FileType.directory,
      children: [projects, documents],
    );

    final home = FileNode(
      id: _uuid.v4(),
      name: 'home',
      type: FileType.directory,
      children: [userHome],
    );

    final newRoot = state.root.copyWith(
      children: [home],
    );

    emit(state.copyWith(root: newRoot, currentPath: '/home/abdisa'));
  }

  // Change Directory
  void cd(String path) {
    if (path == '..') {
      _navigateUp();
      return;
    }

    if (path == '/') {
      emit(state.copyWith(currentPath: '/'));
      return;
    }

    // Handle relative path
    String targetPath;
    if (path.startsWith('/')) {
      targetPath = path;
    } else {
      final separator = state.currentPath == '/' ? '' : '/';
      targetPath = '${state.currentPath}$separator$path';
    }

    final node = state.getNode(targetPath);
    if (node != null && node.isDirectory) {
      emit(state.copyWith(currentPath: targetPath));
    } else {
      // Error handling can be done via side effects or a separate status field
      print('Directory not found: $path'); 
    }
  }

  void _navigateUp() {
    if (state.currentPath == '/') return;

    final parts = state.currentPath.split('/').where((p) => p.isNotEmpty).toList();
    parts.removeLast();
    final newPath = parts.isEmpty ? '/' : '/${parts.join('/')}';
    emit(state.copyWith(currentPath: newPath));
  }

  // Make Directory
  void mkdir(String name) {
    if (name.isEmpty) return;

    final currentDir = state.currentDirectory;
    final newDir = FileNode(
      id: _uuid.v4(),
      name: name,
      type: FileType.directory,
      children: [],
      parentId: currentDir.id,
    );

    _addNodeToPath(state.currentPath, newDir);
  }

  // Create File
  void touch(String name, {String content = ''}) {
    if (name.isEmpty) return;

    final currentDir = state.currentDirectory;
    final newFile = FileNode(
      id: _uuid.v4(),
      name: name,
      type: FileType.file,
      content: content,
      parentId: currentDir.id,
    );

    _addNodeToPath(state.currentPath, newFile);
  }

  // Recursive helper to update the tree immutably
  void _addNodeToPath(String path, FileNode newNode) {
    FileNode updateNodeRecursive(FileNode currentNode, List<String> pathParts) {
      if (pathParts.isEmpty) {
        // Target directory reached, add child
        final updatedChildren = [...?currentNode.children, newNode];
        return currentNode.copyWith(children: updatedChildren);
      }

      final nextPart = pathParts.first;
      final remainingParts = pathParts.sublist(1);

      final updatedChildren = currentNode.children?.map((child) {
        if (child.name == nextPart) {
          return updateNodeRecursive(child, remainingParts);
        }
        return child;
      }).toList();

      return currentNode.copyWith(children: updatedChildren);
    }

    final pathParts = path.split('/').where((p) => p.isNotEmpty).toList();
    final newRoot = updateNodeRecursive(state.root, pathParts);

    emit(state.copyWith(root: newRoot));
  }
}
