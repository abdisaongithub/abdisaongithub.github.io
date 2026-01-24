import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconAsset;
  final List<String> screenshots;
  final List<String> tags;
  final String? githubUrl;
  final String? liveUrl;
  final DateTime date;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    this.screenshots = const [],
    this.tags = const [],
    this.githubUrl,
    this.liveUrl,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconAsset,
    screenshots,
    tags,
    githubUrl,
    liveUrl,
    date,
  ];
}
