import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_manifest.freezed.dart';
part 'project_manifest.g.dart';

@freezed
class ProjectManifest with _$ProjectManifest {
  const factory ProjectManifest({
    required String id,
    required String title,
    required String description,
    required String version,
    required List<String> techStack,
    @Default([]) List<String> tags,
    String? repoUrl,
    String? liveUrl,
    String? iconPath,
    @Default([]) List<String> gallery,
  }) = _ProjectManifest;

  factory ProjectManifest.fromJson(Map<String, dynamic> json) =>
      _$ProjectManifestFromJson(json);
}
