import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_portfolio_app/features/file_system/cubit/file_system_cubit.dart';
import 'package:flutter_portfolio_app/features/file_system/models/file_node.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FileSystemCubit', () {
    late FileSystemCubit fileSystemCubit;

    setUp(() {
      fileSystemCubit = FileSystemCubit();
    });

    tearDown(() {
      fileSystemCubit.close();
    });

    test('initial state is correct', () {
      expect(fileSystemCubit.state.currentPath, '/home/abdisa');
      expect(fileSystemCubit.state.root.children, isNotEmpty);
    });

    blocTest<FileSystemCubit, FileSystemState>(
      'mkdir creates a new directory in current path',
      build: () => fileSystemCubit,
      act: (cubit) => cubit.mkdir('new_folder'),
      verify: (cubit) {
        final currentDir = cubit.state.currentDirectory;
        final newFolder = currentDir.children?.firstWhere((node) => node.name == 'new_folder');
        expect(newFolder, isNotNull);
        expect(newFolder!.type, FileType.directory);
      },
    );

    blocTest<FileSystemCubit, FileSystemState>(
      'touch creates a new file in current path',
      build: () => fileSystemCubit,
      act: (cubit) => cubit.touch('test.txt', content: 'hello'),
      verify: (cubit) {
        final currentDir = cubit.state.currentDirectory;
        final newFile = currentDir.children?.firstWhere((node) => node.name == 'test.txt');
        expect(newFile, isNotNull);
        expect(newFile!.type, FileType.file);
        expect(newFile.content, 'hello');
      },
    );

    blocTest<FileSystemCubit, FileSystemState>(
      'cd changes current path correctly',
      build: () => fileSystemCubit,
      act: (cubit) => cubit.cd('projects'),
      expect: () => [
        isA<FileSystemState>().having((state) => state.currentPath, 'currentPath', '/home/abdisa/projects'),
      ],
    );

    blocTest<FileSystemCubit, FileSystemState>(
      'cd .. navigates to parent directory',
      build: () => fileSystemCubit,
      act: (cubit) async {
        cubit.cd('projects');
        cubit.cd('..');
      },
      expect: () => [
        isA<FileSystemState>().having((state) => state.currentPath, 'currentPath', '/home/abdisa/projects'),
        isA<FileSystemState>().having((state) => state.currentPath, 'currentPath', '/home/abdisa'),
      ],
    );

     blocTest<FileSystemCubit, FileSystemState>(
      'cd to absolute path works',
      build: () => fileSystemCubit,
      act: (cubit) => cubit.cd('/'),
      expect: () => [
        isA<FileSystemState>().having((state) => state.currentPath, 'currentPath', '/'),
      ],
    );
  });
}
