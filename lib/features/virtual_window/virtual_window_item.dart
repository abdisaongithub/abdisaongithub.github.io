import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart'; // For Size, Offset
import 'window_content.dart';

class VirtualWindowItem extends Equatable {
  final String id;
  final WindowContent content;
  final Offset position;
  final Size size;
  final bool isMinimized;
  final bool isMaximized;
  final bool isFocused;

  const VirtualWindowItem({
    required this.id,
    required this.content,
    this.position = const Offset(100, 100),
    this.size = const Size(800, 600),
    this.isMinimized = false,
    this.isMaximized = false,
    this.isFocused = true,
  });

  VirtualWindowItem copyWith({
    Offset? position,
    Size? size,
    bool? isMinimized,
    bool? isMaximized,
    bool? isFocused,
  }) {
    return VirtualWindowItem(
      id: id,
      content: content,
      position: position ?? this.position,
      size: size ?? this.size,
      isMinimized: isMinimized ?? this.isMinimized,
      isMaximized: isMaximized ?? this.isMaximized,
      isFocused: isFocused ?? this.isFocused,
    );
  }

  @override
  List<Object?> get props => [
    id,
    content,
    position,
    size,
    isMinimized,
    isMaximized,
    isFocused,
  ];
}
