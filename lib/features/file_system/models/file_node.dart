import 'package:equatable/equatable.dart';

enum FileType { file, directory }

class FileNode extends Equatable {
  final String id;
  final String name;
  final FileType type;
  final String? content; // For simple text files
  final List<FileNode>? children; // For directories
  final String? parentId;

  const FileNode({
    required this.id,
    required this.name,
    required this.type,
    this.content,
    this.children,
    this.parentId,
  });

  // Root constructor
  factory FileNode.root({List<FileNode>? children}) {
    return FileNode(
      id: 'root',
      name: '/',
      type: FileType.directory,
      children: children ?? [],
    );
  }

  // Helper to check if it's a directory
  bool get isDirectory => type == FileType.directory;

  FileNode copyWith({
    String? id,
    String? name,
    FileType? type,
    String? content,
    List<FileNode>? children,
    String? parentId,
  }) {
    return FileNode(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      content: content ?? this.content,
      children: children ?? this.children,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  List<Object?> get props => [id, name, type, content, children, parentId];
}
