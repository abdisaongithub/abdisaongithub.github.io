import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/profile.dart';
import '../services/github_service.dart';

class GithubState extends Equatable {
  final GithubProfile? profile;
  final List<GithubRepo> repos;
  final bool isLoading;

  /// True once a fetch has finished without producing a profile — usually the
  /// unauthenticated 60/hour rate limit. The UI degrades instead of hanging on
  /// a spinner forever.
  final bool hasFailed;

  const GithubState({
    this.profile,
    this.repos = const [],
    this.isLoading = true,
    this.hasFailed = false,
  });

  int get totalStars => repos.fold(0, (sum, repo) => sum + repo.stars);

  /// Distinct languages across public repos, most used first.
  List<String> get languages {
    final counts = <String, int>{};
    for (final repo in repos) {
      final language = repo.language;
      if (language == null) continue;
      counts[language] = (counts[language] ?? 0) + 1;
    }
    final sorted = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return sorted;
  }

  GithubState copyWith({
    GithubProfile? profile,
    List<GithubRepo>? repos,
    bool? isLoading,
    bool? hasFailed,
  }) {
    return GithubState(
      profile: profile ?? this.profile,
      repos: repos ?? this.repos,
      isLoading: isLoading ?? this.isLoading,
      hasFailed: hasFailed ?? this.hasFailed,
    );
  }

  @override
  List<Object?> get props => [profile, repos, isLoading, hasFailed];
}

class GithubCubit extends Cubit<GithubState> {
  GithubCubit(this._service, {bool autoLoad = true})
      : super(const GithubState()) {
    if (autoLoad) load();
  }

  final GithubService _service;

  Future<void> load() async {
    if (!isClosed) emit(state.copyWith(isLoading: true, hasFailed: false));

    final results = await Future.wait([
      _service.getProfile(Profile.username),
      _service.getRepos(Profile.username),
    ]);

    if (isClosed) return;

    final profile = results[0] as GithubProfile?;
    final repos = results[1] as List<GithubRepo>;

    emit(
      GithubState(
        profile: profile,
        repos: repos,
        isLoading: false,
        hasFailed: profile == null,
      ),
    );
  }
}
