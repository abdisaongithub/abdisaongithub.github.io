// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectManifestImpl _$$ProjectManifestImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectManifestImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      version: json['version'] as String,
      techStack:
          (json['techStack'] as List<dynamic>).map((e) => e as String).toList(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      repoUrl: json['repoUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      iconPath: json['iconPath'] as String?,
      gallery: (json['gallery'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProjectManifestImplToJson(
        _$ProjectManifestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'version': instance.version,
      'techStack': instance.techStack,
      'tags': instance.tags,
      'repoUrl': instance.repoUrl,
      'liveUrl': instance.liveUrl,
      'iconPath': instance.iconPath,
      'gallery': instance.gallery,
    };
