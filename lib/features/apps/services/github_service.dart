import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A GitHub profile, reduced to what the UI actually shows.
class GithubProfile extends Equatable {
  final String login;
  final String name;
  final String? bio;
  final String? location;
  final int publicRepos;
  final int followers;
  final int following;
  final String avatarUrl;
  final String htmlUrl;

  const GithubProfile({
    required this.login,
    required this.name,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.avatarUrl,
    required this.htmlUrl,
    this.bio,
    this.location,
  });

  /// Accepts GitHub's own field names, which the snapshot preserves.
  factory GithubProfile.fromJson(Map<String, dynamic> json) {
    return GithubProfile(
      login: json['login'] as String? ?? '',
      name: json['name'] as String? ?? json['login'] as String? ?? '',
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      publicRepos: (json['public_repos'] as num?)?.toInt() ?? 0,
      followers: (json['followers'] as num?)?.toInt() ?? 0,
      following: (json['following'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatar_url'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        login,
        name,
        bio,
        location,
        publicRepos,
        followers,
        following,
        avatarUrl,
        htmlUrl,
      ];
}

class GithubRepo extends Equatable {
  final String name;
  final String? description;
  final String? language;
  final int stars;
  final String htmlUrl;
  final DateTime? pushedAt;

  const GithubRepo({
    required this.name,
    required this.stars,
    required this.htmlUrl,
    this.description,
    this.language,
    this.pushedAt,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      language: json['language'] as String?,
      stars: (json['stargazers_count'] as num?)?.toInt() ?? 0,
      htmlUrl: json['html_url'] as String? ?? '',
      pushedAt: DateTime.tryParse(json['pushed_at'] as String? ?? ''),
    );
  }

  @override
  List<Object?> get props => [name, description, language, stars, htmlUrl];
}

/// GitHub data, read from a snapshot bundled with the app.
///
/// The app used to call api.github.com from every visitor's browser. Those
/// calls are unauthenticated, limited to 60 per hour per IP, and many visitors
/// share a single public IP behind carrier-grade NAT — so the limit was spent
/// for everyone at once and the API answered 403.
///
/// `tool/fetch_github_snapshot.dart` now fetches the data once per deploy using
/// the CI token and writes [snapshotAsset]. At runtime this is a same-origin
/// asset read: no third-party request, no rate limit, and it is cached by the
/// service worker like everything else.
class GithubService {
  GithubService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String snapshotAsset = 'assets/data/github_snapshot.json';

  final AssetBundle _bundle;
  Future<_Snapshot?>? _snapshot;

  Future<GithubProfile?> getProfile() async => (await _load())?.profile;

  Future<List<GithubRepo>> getRepos() async =>
      (await _load())?.repos ?? const [];

  /// Parsed once and shared by every caller.
  Future<_Snapshot?> _load() => _snapshot ??= _read();

  Future<_Snapshot?> _read() async {
    try {
      final raw = await _bundle.loadString(snapshotAsset);
      final json = jsonDecode(raw) as Map<String, dynamic>;

      final profileJson = json['profile'];
      final reposJson = json['repos'];

      return _Snapshot(
        profile: profileJson is Map<String, dynamic>
            ? GithubProfile.fromJson(profileJson)
            : null,
        repos: reposJson is List
            ? reposJson
                .whereType<Map<String, dynamic>>()
                .map(GithubRepo.fromJson)
                .toList()
            : const [],
      );
    } catch (e) {
      debugPrint('GitHub snapshot unavailable: $e');
      return null;
    }
  }
}

class _Snapshot {
  final GithubProfile? profile;
  final List<GithubRepo> repos;

  const _Snapshot({required this.profile, required this.repos});
}
