import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/projects/project.dart';

void main() {
  group('project data', () {
    test('every project has the fields a card needs', () {
      for (final project in kProjects) {
        expect(project.id, isNotEmpty, reason: project.title);
        expect(project.title, isNotEmpty);
        expect(project.summary, isNotEmpty, reason: project.title);
        expect(project.description, isNotEmpty, reason: project.title);
        expect(project.tech, isNotEmpty, reason: project.title);
        expect(project.links, isNotEmpty, reason: project.title);
      }
    });

    test('ids are unique', () {
      final ids = kProjects.map((p) => p.id).toSet();
      expect(ids, hasLength(kProjects.length));
    });

    // A portfolio caught shipping a dead link is worse than shipping nothing.
    test('every link is an absolute https url', () {
      for (final project in kProjects) {
        for (final link in project.links) {
          final uri = Uri.tryParse(link.url);
          expect(uri, isNotNull, reason: '${project.title}: ${link.url}');
          expect(
            uri!.scheme,
            'https',
            reason: '${project.title}: ${link.url}',
          );
          expect(uri.host, isNotEmpty, reason: '${project.title}: ${link.url}');
        }
      }
    });

    test('summaries stay short enough to read at a glance', () {
      for (final project in kProjects) {
        expect(
          project.summary.length,
          lessThanOrEqualTo(90),
          reason: '${project.title} summary is too long for a card',
        );
      }
    });

    test('at least one project is featured', () {
      expect(kFeaturedProjects, isNotEmpty);
    });

    test('projects with a video are discoverable', () {
      for (final project in kProjectsWithVideo) {
        expect(project.videoId, isNotNull);
        expect(project.videoId, isNotEmpty);
      }
    });

    test('skills groups are populated', () {
      expect(kSkills, isNotEmpty);
      for (final group in kSkills.entries) {
        expect(group.value, isNotEmpty, reason: group.key);
      }
    });
  });
}
