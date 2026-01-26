import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // We will create this next

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  final List<String> _bootSequence = [
    'BIOS Date 01/25/26 12:35:03 Ver: 1.0.0',
    'CPU: Flutter Web Engine v3.x',
    'Memory Test: 640K OK',
    ' ',
    'Detecting Primary Master ... Abdisa Portfolio',
    'Detecting Primary Slave  ... GitHub Projects',
    'Detecting Secondary Master ... Skills & Experience',
    ' ',
    'Booting from local disk...',
    'Loading Kernel...',
    'Mounting /home/abdisa...',
    'Starting System Services...',
    'Loading UI Framework...',
    'Initializing Graphics...',
    'System Ready.',
    ' ',
    'Press any key to continue... (Auto-starting in 3s)',
  ];

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  Future<void> _startBootSequence() async {
    for (final line in _bootSequence) {
      if (!mounted) return;
      await Future.delayed(
          Duration(milliseconds: line.trim().isEmpty ? 500 : 150));
      setState(() {
        _logs.add(line);
      });
      _scrollToBottom();
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      _navigateToLogin();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Retro Header
            const Text(
              'Abdisa BIOS (C) 2026 Energy Star Ally',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.white),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return Text(
                    _logs[index],
                    style: const TextStyle(
                      color: Color(0xFFCCCCCC), // Retro grey/white
                      fontFamily: 'Courier',
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Blinking Cursor
            Row(
              children: [
                const Text('_',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Courier')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
