import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

  factory GithubProfile.fromJson(Map<String, dynamic> json) {
    return GithubProfile(
      login: json['login'] as String? ?? '',
      name: json['name'] as String? ?? json['login'] as String? ?? '',
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      publicRepos: json['public_repos'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
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
      stars: json['stargazers_count'] as int? ?? 0,
      htmlUrl: json['html_url'] as String? ?? '',
      pushedAt: DateTime.tryParse(json['pushed_at'] as String? ?? ''),
    );
  }

  @override
  List<Object?> get props => [name, description, language, stars, htmlUrl];
}

/// Thin GitHub REST client.
///
/// Unauthenticated calls are rate limited to 60/hour per IP, so results are
/// memoised for the life of the session and every failure degrades to null
/// rather than throwing into the widget tree.
class GithubService {
  GithubService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.github.com/',
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
                headers: const {'Accept': 'application/vnd.github+json'},
              ),
            );

  final Dio _dio;

  Future<GithubProfile?>? _profileRequest;
  Future<List<GithubRepo>>? _reposRequest;

  Future<GithubProfile?> getProfile(String username) {
    // Several surfaces mount the status widget at once; share one request.
    return _profileRequest ??= _fetchProfile(username);
  }

  Future<GithubProfile?> _fetchProfile(String username) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('users/$username');
      final data = response.data;
      if (data == null) return null;
      return GithubProfile.fromJson(data);
    } catch (e) {
      debugPrint('GitHub profile unavailable: $e');
      // Let a later mount retry rather than caching the failure forever.
      _profileRequest = null;
      return null;
    }
  }

  Future<List<GithubRepo>> getRepos(String username) {
    return _reposRequest ??= _fetchRepos(username);
  }

  Future<List<GithubRepo>> _fetchRepos(String username) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        'users/$username/repos',
        queryParameters: const {'per_page': 100, 'sort': 'pushed'},
      );
      final data = response.data ?? const [];
      return data
          .whereType<Map<String, dynamic>>()
          .where((json) => json['fork'] != true)
          .map(GithubRepo.fromJson)
          .toList();
    } catch (e) {
      debugPrint('GitHub repos unavailable: $e');
      _reposRequest = null;
      return const [];
    }
  }
}
