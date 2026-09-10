import 'package:flutter_portfolio_app/core/platform_detector.dart';
import 'package:flutter_portfolio_app/features/apps/services/github_service.dart';
import 'package:flutter_portfolio_app/features/file_system/models/project_manifest.dart';
import 'package:flutter_portfolio_app/features/file_system/services/project_loader_service.dart';
import 'package:flutter_portfolio_app/features/os_mode/os_mode.dart';

/// Pins a device profile so tests never depend on what the host reports.
DeviceProfile detectedIs(OSMode mode, {bool isHandset = false}) =>
    DeviceProfile(osMode: mode, isHandset: isHandset);

/// Loads no projects, so a test only observes the state it triggers itself.
/// The real loader kicks off an async asset read from the constructor.
class EmptyLoader extends ProjectLoaderService {
  @override
  Future<List<ProjectManifest>> loadAllProjects() async => const [];
}

/// Answers instantly instead of hitting api.github.com, which otherwise leaves
/// a pending timer and fails any widget test that mounts the status widget.
class OfflineGithubService extends GithubService {
  @override
  Future<Map<String, dynamic>> getUserStats(String username) async => const {};

  @override
  Future<List<dynamic>> getRecentCommits(String username) async => const [];
}
