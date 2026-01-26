import 'package:flutter/material.dart';
import '../services/github_service.dart';

class GithubStatusWidget extends StatefulWidget {
  final String username;
  const GithubStatusWidget({super.key, required this.username});

  @override
  State<GithubStatusWidget> createState() => _GithubStatusWidgetState();
}

class _GithubStatusWidgetState extends State<GithubStatusWidget> {
  final _service = GithubService();
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _service.getUserStats(widget.username);
    if (mounted) {
      setState(() {
        _stats = stats;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }

    if (_stats == null || _stats!.isEmpty) {
      return const Icon(Icons.error_outline, color: Colors.red, size: 20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.code, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '${_stats!['public_repos']} Repos',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.star_border, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            '${_stats!['followers']} Followers',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
