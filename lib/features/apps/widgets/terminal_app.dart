import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../file_system/cubit/file_system_cubit.dart';

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

  void _handleCommand(String command) {
    if (command.trim().isEmpty) return;

    final currentPath = context.read<FileSystemCubit>().state.currentPath;

    setState(() {
      _history.add('abdisa@os:$currentPath\$ $command');
      final output = _processCommand(command.trim());
      if (output != null && output.isNotEmpty) _history.add(output);
    });

    _controller.clear();
    _scrollToBottom();
  }

  String? _processCommand(String input) {
    final parts = input.split(' ');
    final cmd = parts[0].toLowerCase();
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    final fsCubit = context.read<FileSystemCubit>();

    switch (cmd) {
      case 'help':
        return 'Available commands:\n'
            '  help     - Show this help message\n'
            '  about    - Who am I?\n'
            '  contact  - Get contact info\n'
            '  clear    - Clear terminal\n'
            '  ls       - List directory contents\n'
            '  cd <dir> - Change directory\n'
            '  mkdir <name> - Create directory\n'
            '  touch <name> - Create file\n'
            '  pwd      - Print working directory';
      case 'about':
        return 'I am Abdisa Tsegaye, a Flutter Developer passionate about building beautiful UIs.';
      case 'contact':
        return 'Email: abdisa.tsegaye@gmail.com\nPhone: +251 911 364 379';
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
        fsCubit.cd(args[0]);
        return null;
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
      default:
        return 'Command not found: $cmd. Type "help" for assistance.';
    }
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
        return Container(
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
                      child: Text(
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
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Color(0xFF00FF00),
                        fontFamily: 'Courier',
                      ),
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
