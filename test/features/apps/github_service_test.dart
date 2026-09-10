import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/core/profile.dart';
import 'package:flutter_portfolio_app/features/apps/github/github_cubit.dart';
import 'package:flutter_portfolio_app/features/apps/services/github_service.dart';

/// Serves a fixed string for any asset key, or fails like a missing asset.
class _FakeBundle extends CachingAssetBundle {
  final String? body;
  int reads = 0;

  _FakeBundle(this.body);

  @override
  Future<ByteData> load(String key) async {
    final text = await loadString(key);
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(text)));
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    reads++;
    if (body == null) throw Exception('Unable to load asset: "$key"');
    return body!;
  }
}

const _snapshot = '''
{
  "generatedAt": "2026-09-11T00:00:00Z",
  "profile": {
    "login": "someone",
    "name": "Some One",
    "public_repos": 32,
    "followers": 11,
    "following": 4,
    "avatar_url": "https://example.com/a.png",
    "html_url": "https://github.com/someone"
  },
  "repos": [
    {"name": "a", "language": "Dart", "stargazers_count": 3,
     "html_url": "https://github.com/someone/a", "pushed_at": "2026-01-01T00:00:00Z"},
    {"name": "b", "language": "TypeScript", "stargazers_count": 1,
     "html_url": "https://github.com/someone/b", "pushed_at": null}
  ]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GithubService', () {
    test('reads profile and repos from the bundled snapshot', () async {
      final service = GithubService(bundle: _FakeBundle(_snapshot));

      final profile = await service.getProfile();
      final repos = await service.getRepos();

      expect(profile!.publicRepos, 32);
      expect(profile.followers, 11);
      expect(repos.map((r) => r.name), ['a', 'b']);
      expect(repos.first.stars, 3);
    });

    test('reads the asset once and shares it between callers', () async {
      final bundle = _FakeBundle(_snapshot);
      final service = GithubService(bundle: bundle);

      await Future.wait([
        service.getProfile(),
        service.getRepos(),
        service.getProfile(),
      ]);

      expect(bundle.reads, 1);
    });

    // A missing or corrupt snapshot must degrade to "no stats", never throw
    // into the widget tree.
    test('a missing snapshot degrades to no data', () async {
      final service = GithubService(bundle: _FakeBundle(null));

      expect(await service.getProfile(), isNull);
      expect(await service.getRepos(), isEmpty);
    });

    test('a malformed snapshot degrades to no data', () async {
      final service = GithubService(bundle: _FakeBundle('{not json'));

      expect(await service.getProfile(), isNull);
      expect(await service.getRepos(), isEmpty);
    });

    // Regression guard: the committed snapshot must exist, be declared in
    // pubspec.yaml, and describe the right account.
    test('the committed snapshot is bundled and parses', () async {
      final service = GithubService();

      final profile = await service.getProfile();

      expect(
        profile,
        isNotNull,
        reason: 'Run: dart run tool/fetch_github_snapshot.dart',
      );
      expect(profile!.login, Profile.username);
      expect(profile.publicRepos, greaterThan(0));
    });
  });

  group('GithubCubit', () {
    test('finishes loading from the snapshot without failing', () async {
      final cubit = GithubCubit(
        GithubService(bundle: _FakeBundle(_snapshot)),
        autoLoad: false,
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.hasFailed, isFalse);
      expect(cubit.state.languages, ['Dart', 'TypeScript']);
    });

    test('marks itself failed, not loading, when there is no data', () async {
      final cubit = GithubCubit(
        GithubService(bundle: _FakeBundle(null)),
        autoLoad: false,
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.hasFailed, isTrue);
    });
  });
}
