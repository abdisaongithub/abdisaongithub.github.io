import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/file_system/services/project_loader_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProjectLoaderService', () {
    // Regression guard for the pubspec.yaml asset bug: `assets/projects/` is
    // NOT recursive, so every project folder must be declared explicitly or
    // its manifest is never bundled and the whole VFS silently comes up empty.
    test('every declared project manifest is bundled and parses', () async {
      final projects = await ProjectLoaderService().loadAllProjects();

      expect(
        projects,
        hasLength(3),
        reason: 'A manifest failed to load — check the assets: entries in '
            'pubspec.yaml declare each assets/projects/<id>/ folder.',
      );
      expect(
        projects.map((p) => p.id),
        containsAll(['portfolio', 'ecommerce-app', 'task-manager']),
      );
      for (final project in projects) {
        expect(project.title, isNotEmpty);
        expect(project.techStack, isNotEmpty);
      }
    });

    test('loadManifest throws a descriptive error for a missing asset', () {
      expect(
        () => ProjectLoaderService().loadManifest('assets/projects/nope.json'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to load project manifest'),
          ),
        ),
      );
    });
  });
}
