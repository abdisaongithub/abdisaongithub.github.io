part of 'file_system_cubit.dart';

class FileSystemState extends Equatable {
  final FileNode root;
  final String currentPath;

  const FileSystemState({
    required this.root,
    this.currentPath = '/',
  });

  // Helper to find a node by path
  FileNode? getNode(String path) {
    if (path == '/') return root;

    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    FileNode? current = root;

    for (final part in parts) {
      if (current?.children == null) return null;
      try {
        current = current!.children!.firstWhere((node) => node.name == part);
      } catch (e) {
        return null;
      }
    }
    return current;
  }

  // Get current directory node
  FileNode get currentDirectory => getNode(currentPath) ?? root;

  FileSystemState copyWith({
    FileNode? root,
    String? currentPath,
  }) {
    return FileSystemState(
      root: root ?? this.root,
      currentPath: currentPath ?? this.currentPath,
    );
  }

  @override
  List<Object> get props => [root, currentPath];
}
