// Fetches GitHub profile and repository data at build time and writes it to
// assets/data/github_snapshot.json, which the app bundles.
//
// Why this exists: the site used to call api.github.com from every visitor's
// browser. Unauthenticated calls are limited to 60 per hour *per IP*, and many
// visitors share one public IP behind carrier-grade NAT, so the limit ran out
// for everyone at once and the API answered 403. Fetching once per deploy, with
// the CI token, removes that dependency from the page entirely.
//
// Usage:
//   GITHUB_TOKEN=... dart run tool/fetch_github_snapshot.dart
//
// A token is optional locally but strongly recommended (5000/hour vs 60/hour).
// If the fetch fails and a snapshot already exists, the existing one is kept
// and the script exits successfully, so a GitHub outage never blocks a deploy.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_portfolio_app/core/profile.dart';

const _outputPath = 'assets/data/github_snapshot.json';

const _profileFields = [
  'login',
  'name',
  'bio',
  'location',
  'public_repos',
  'followers',
  'following',
  'avatar_url',
  'html_url',
];

const _repoFields = [
  'name',
  'description',
  'language',
  'stargazers_count',
  'html_url',
  'pushed_at',
];

Future<void> main() async {
  final output = File(_outputPath);
  final token = Platform.environment['GITHUB_TOKEN'];

  try {
    final profile = await _getJson('users/${Profile.username}', token);
    final repos = await _getJson(
      'users/${Profile.username}/repos?per_page=100&sort=pushed',
      token,
    );

    final snapshot = {
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'profile': _pick(profile as Map<String, dynamic>, _profileFields),
      'repos': (repos as List)
          .whereType<Map<String, dynamic>>()
          .where((repo) => repo['fork'] != true)
          .map((repo) => _pick(repo, _repoFields))
          .toList(),
    };

    await output.parent.create(recursive: true);
    await output.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(snapshot)}\n',
    );
    stdout.writeln(
      'Wrote $_outputPath: ${(snapshot['repos'] as List).length} repos, '
      '${(snapshot['profile'] as Map)['followers']} followers.',
    );
  } catch (e) {
    if (await output.exists()) {
      stderr.writeln('GitHub fetch failed ($e); keeping existing snapshot.');
      return;
    }
    stderr.writeln('GitHub fetch failed and no snapshot exists: $e');
    exitCode = 1;
  }
}

Future<Object?> _getJson(String path, String? token) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
  try {
    final request = await client.getUrl(
      Uri.parse('https://api.github.com/$path'),
    );
    request.headers
      ..set(HttpHeaders.acceptHeader, 'application/vnd.github+json')
      ..set(HttpHeaders.userAgentHeader, 'abdisaongithub-portfolio-build');
    if (token != null && token.isNotEmpty) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    }

    final response = await request.close().timeout(
          const Duration(seconds: 30),
        );
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('GET $path -> ${response.statusCode}: $body');
    }
    return jsonDecode(body);
  } finally {
    client.close(force: true);
  }
}

Map<String, dynamic> _pick(Map<String, dynamic> source, List<String> keys) => {
      for (final key in keys) key: source[key],
    };
