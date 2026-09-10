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

/// Answers instantly with no data, for widget tests that do not care about
/// GitHub stats.
class OfflineGithubService extends GithubService {
  @override
  Future<GithubProfile?> getProfile() async => null;

  @override
  Future<List<GithubRepo>> getRepos() async => const [];
}
