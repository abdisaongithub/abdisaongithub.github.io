import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio_app/features/file_system/cubit/file_system_cubit.dart';
import 'package:flutter_portfolio_app/features/file_system/models/file_node.dart';
import 'package:flutter_portfolio_app/features/file_system/models/project_manifest.dart';
import 'package:flutter_portfolio_app/features/file_system/services/project_loader_service.dart';

import '../../../support/test_harness.dart';

class _FakeLoader extends ProjectLoaderService {
  @override
  Future<List<ProjectManifest>> loadAllProjects() async => const [
        ProjectManifest(
          id: 'demo-project',
          title: 'Demo Project',
          description: 'A demo.',
          version: '1.0.0',
          techStack: ['Dart'],
        ),
      ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FileSystemCubit', () {
    late FileSystemCubit cubit;

    setUp(() => cubit = FileSystemCubit(projectLoader: EmptyLoader()));
    tearDown(() => cubit.close());

    test('starts in the home directory with a populated tree', () {
      expect(cubit.state.currentPath, FileSystemCubit.homePath);
      expect(cubit.state.root.children, isNotEmpty);
      expect(cubit.state.getNode(FileSystemCubit.projectsPath), isNotNull);
    });

    test('mkdir creates a directory in the current path', () {
      cubit.mkdir('new_folder');

      final created = cubit.state.currentDirectory.children!.firstWhere(
        (node) => node.name == 'new_folder',
      );
      expect(created.type, FileType.directory);
    });

    test('touch creates a file with content', () {
      cubit.touch('test.txt', content: 'hello');

      final created = cubit.state.currentDirectory.children!.firstWhere(
        (node) => node.name == 'test.txt',
      );
      expect(created.type, FileType.file);
      expect(created.content, 'hello');
    });

    test('mkdir and touch ignore empty names', () {
      final before = cubit.state.currentDirectory.children!.length;
      cubit.mkdir('');
      cubit.touch('');
      expect(cubit.state.currentDirectory.children!.length, before);
    });

    test('cd navigates into a child directory', () {
      expect(cubit.cd('projects'), isNull);
      expect(cubit.state.currentPath, FileSystemCubit.projectsPath);
    });

    test('cd .. navigates to the parent', () {
      cubit.cd('projects');
      cubit.cd('..');
      expect(cubit.state.currentPath, FileSystemCubit.homePath);
    });

    test('cd .. at the root is a no-op', () {
      cubit.cd('/');
      cubit.cd('..');
      expect(cubit.state.currentPath, '/');
    });

    test('cd handles absolute paths and ~', () {
      cubit.cd('/');
      expect(cubit.state.currentPath, '/');

      cubit.cd(FileSystemCubit.projectsPath);
      expect(cubit.state.currentPath, FileSystemCubit.projectsPath);

      cubit.cd('~');
      expect(cubit.state.currentPath, FileSystemCubit.homePath);
    });

    // Regression: cd used to `print` the failure and leave the caller with no
    // way to know anything went wrong.
    test('cd reports an error instead of silently failing', () {
      final error = cubit.cd('nope');
      expect(error, contains('No such file or directory'));
      expect(cubit.state.currentPath, FileSystemCubit.homePath);
    });

    test('cd into a file reports "Not a directory"', () {
      cubit.touch('readme.txt');
      expect(cubit.cd('readme.txt'), contains('Not a directory'));
    });

    test('getNode returns null for a path that does not exist', () {
      expect(cubit.state.getNode('/home/abdisa/missing'), isNull);
    });
  });

  group('FileSystemCubit project loading', () {
    test('mounts loaded projects under the projects directory', () async {
      final cubit = FileSystemCubit(projectLoader: _FakeLoader());
      addTearDown(cubit.close);

      // Let the constructor's async load settle.
      await Future<void>.delayed(Duration.zero);

      final projects = cubit.state.getNode(FileSystemCubit.projectsPath);
      final demo = projects!.children!.firstWhere(
        (node) => node.name == 'demo-project',
      );

      expect(demo.type, FileType.directory);
      expect(
        demo.children!.map((node) => node.name),
        containsAll(['manifest.json', 'README.md']),
      );
    });
  });
}
