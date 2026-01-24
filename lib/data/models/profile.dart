import 'package:equatable/equatable.dart';

class SocialLink extends Equatable {
  final String name;
  final String url;
  final String iconAsset; // Or use IconData if using font_awesome

  const SocialLink({
    required this.name,
    required this.url,
    required this.iconAsset,
  });

  @override
  List<Object?> get props => [name, url, iconAsset];
}

class Profile extends Equatable {
  final String name;
  final String role;
  final String bio;
  final String avatarAsset;
  final List<SocialLink> socialLinks;
  final List<String> skills;

  const Profile({
    required this.name,
    required this.role,
    required this.bio,
    required this.avatarAsset,
    this.socialLinks = const [],
    this.skills = const [],
  });

  @override
  List<Object?> get props => [
    name,
    role,
    bio,
    avatarAsset,
    socialLinks,
    skills,
  ];
}
