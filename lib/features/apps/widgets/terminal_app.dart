import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/profile.dart';
import '../../file_system/cubit/file_system_cubit.dart';
import '../../file_system/models/file_node.dart';
import '../../virtual_window/cubit/window_manager_cubit.dart';
import '../../virtual_window/window_content.dart';

class TerminalApp extends StatefulWidget {
  const TerminalApp({super.key});

  @override
  State<TerminalApp> createState() => _TerminalAppState();
}

class _TerminalAppState extends State<TerminalApp> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _history = [
    'Welcome to Abdisa OS v1.0.0',
    'Type "help" for a list of commands.',
  ];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  /// Previously entered commands, newest last, navigable with arrow keys.
  final List<String> _commandHistory = [];
  int _historyCursor = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCommand(String command) {
    if (command.trim().isEmpty) return;

    final currentPath = context.read<FileSystemCubit>().state.currentPath;

    setState(() {
      _history.add('abdisa@os:$currentPath\$ $command');
      final output = _processCommand(command.trim());
      if (output != null && output.isNotEmpty) _history.add(output);
      _commandHistory.add(command);
      _historyCursor = _commandHistory.length;
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _recallHistory(int direction) {
    if (_commandHistory.isEmpty) return;

    final next = (_historyCursor + direction).clamp(0, _commandHistory.length);
    setState(() => _historyCursor = next);

    final text = next == _commandHistory.length ? '' : _commandHistory[next];
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String? _processCommand(String input) {
    final parts = input.split(' ').where((p) => p.isNotEmpty).toList();
    final cmd = parts[0].toLowerCase();
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    final fsCubit = context.read<FileSystemCubit>();

    switch (cmd) {
      case 'help':
        return 'Available commands:\n'
            '  help         - Show this help message\n'
            '  about        - Who am I?\n'
            '  contact      - Get contact info\n'
            '  clear        - Clear terminal\n'
            '  ls           - List directory contents\n'
            '  cd <dir>     - Change directory\n'
            '  cat <file>   - Print file contents\n'
            '  open <file>  - Open a file in its app\n'
            '  mkdir <name> - Create directory\n'
            '  touch <name> - Create file\n'
            '  pwd          - Print working directory';
      case 'about':
        return 'I am ${Profile.name}, a ${Profile.tagline} passionate about '
            'building beautiful UIs.';
      case 'contact':
        return 'Email: ${Profile.email}\n'
            'Phone: ${Profile.phoneDisplay}\n'
            'GitHub: ${Profile.githubUrl}';
      case 'clear':
        setState(() => _history.clear());
        return null;
      case 'ls':
        final children = fsCubit.state.currentDirectory.children;
        if (children == null || children.isEmpty) return '';
        return children.map((node) {
          final prefix = node.isDirectory ? 'd' : '-';
          return '$prefix ${node.name}';
        }).join('\n');
      case 'cd':
        if (args.isEmpty) return null;
        final error = fsCubit.cd(args[0]);
        return error;
      case 'mkdir':
        if (args.isEmpty) return 'usage: mkdir <directory_name>';
        fsCubit.mkdir(args[0]);
        return 'Created directory: ${args[0]}';
      case 'touch':
        if (args.isEmpty) return 'usage: touch <file_name>';
        fsCubit.touch(args[0]);
        return 'Created file: ${args[0]}';
      case 'pwd':
        return fsCubit.state.currentPath;
      case 'cat':
        if (args.isEmpty) return 'usage: cat <file_name>';
        final file = _findFile(args[0]);
        if (file == null) return 'cat: ${args[0]}: No such file';
        return file.content ?? '';
      case 'open':
        if (args.isEmpty) return 'usage: open <file_name>';
        return _open(args[0]);
      default:
        return 'Command not found: $cmd. Type "help" for assistance.';
    }
  }

  /// Looks up a file in the current directory.
  ///
  /// This used to use `firstWhere(orElse: () => throw ...)`, which propagated
  /// out of the command handler instead of printing a "not found" message.
  FileNode? _findFile(String name) {
    final children =
        context.read<FileSystemCubit>().state.currentDirectory.children;
    if (children == null) return null;
    for (final node in children) {
      if (node.name == name && !node.isDirectory) return node;
    }
    return null;
  }

  String _open(String fileName) {
    final file = _findFile(fileName);
    if (file == null) return 'open: $fileName: No such file';

    final lower = fileName.toLowerCase();
    final windows = context.read<WindowManagerCubit>();

    if (lower.endsWith('.md')) {
      windows.openWindow(
        WindowContent(
          type: WindowContentType.markdown,
          title: fileName,
          data: file.content,
        ),
      );
      return 'Opening $fileName...';
    }

    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg')) {
      windows.openWindow(
        WindowContent(
          type: WindowContentType.gallery,
          title: fileName,
          data: <String>[file.content ?? ''],
        ),
      );
      return 'Opening $fileName...';
    }

    return 'Content of $fileName:\n${file.content ?? ''}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileSystemCubit, FileSystemState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _focusNode.requestFocus,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: SelectableText(
                          _history[index],
                          style: const TextStyle(
                            color: Color(0xFF00FF00),
                            fontFamily: 'Courier',
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                Row(
                  children: [
                    Text(
                      'abdisa@os:${state.currentPath}\$ ',
                      style: const TextStyle(
                        color: Color(0xFF00FF00),
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Shortcuts(
                        shortcuts: const {
                          SingleActivator(LogicalKeyboardKey.arrowUp):
                              _HistoryIntent(-1),
                          SingleActivator(LogicalKeyboardKey.arrowDown):
                              _HistoryIntent(1),
                        },
                        child: Actions(
                          actions: {
                            _HistoryIntent: CallbackAction<_HistoryIntent>(
                              onInvoke: (intent) {
                                _recallHistory(intent.direction);
                                return null;
                              },
                            ),
                          },
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: true,
                            style: const TextStyle(
                              color: Color(0xFF00FF00),
                              fontFamily: 'Courier',
                            ),
                            cursorColor: const Color(0xFF00FF00),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (_) {
                              _handleCommand(_controller.text);
                              _focusNode.requestFocus();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HistoryIntent extends Intent {
  final int direction;
  const _HistoryIntent(this.direction);
}
