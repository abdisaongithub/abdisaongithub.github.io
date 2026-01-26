import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/project_manifest.dart';

class ProjectLoaderService {
  final AssetBundle _assetBundle;

  ProjectLoaderService({AssetBundle? assetBundle})
      : _assetBundle = assetBundle ?? rootBundle;

  /// Loads and parses a manifest.json from the given asset path.
  Future<ProjectManifest> loadManifest(String path) async {
    try {
      final jsonString = await _assetBundle.loadString(path);
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return ProjectManifest.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load project manifest at $path: $e');
    }
  }

  /// Scans the assets/projects directory (simulated via known list for now
  /// since Flutter Web assets are static) and returns all manifests.
  /// 
  /// In a real dynamic scenario, we might fetch a master 'index.json' first.
  Future<List<ProjectManifest>> loadAllProjects() async {
    // TODO: In the future, generate an index.json during build to avoid hardcoding paths.
    // For now, we manually list known projects.
    const projectPaths = [
      'assets/projects/portfolio/manifest.json',
    ];

    final List<ProjectManifest> projects = [];

    for (final path in projectPaths) {
      try {
        final project = await loadManifest(path);
        projects.add(project);
      } catch (e) {
        // Log error but continue loading others
        print('Error loading project $path: $e');
      }
    }

    return projects;
  }
}
