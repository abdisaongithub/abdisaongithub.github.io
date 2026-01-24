import 'models/profile.dart';
import 'models/project.dart';

class DataConstants {
  static const Profile profile = Profile(
    name: 'Abdisa',
    role: 'Full Stack Developer',
    bio: 'Passionate developer creating cross-platform experiences.',
    avatarAsset: 'assets/images/avatar.png',
    socialLinks: [
      SocialLink(
        name: 'GitHub',
        url: 'https://github.com/abdisaongithub',
        iconAsset: 'assets/icons/github.png',
      ),
      SocialLink(
        name: 'LinkedIn',
        url: 'https://linkedin.com',
        iconAsset: 'assets/icons/linkedin.png',
      ),
    ],
    skills: ['Flutter', 'Dart', 'Python', 'Firebase', 'React', 'Linux'],
  );

  static final List<Project> projects = [
    Project(
      id: '1',
      title: 'Portfolio OS',
      description: 'A portfolio disguised as an operating system.',
      iconAsset: 'assets/icons/folder_project.png',
      date: DateTime(2023, 10, 1),
      tags: const ['Flutter', 'Web', 'Desktop'],
    ),
    Project(
      id: '2',
      title: 'E-Commerce App',
      description: 'Full featured shopping app with payment integration.',
      iconAsset: 'assets/icons/folder_project.png',
      date: DateTime(2023, 8, 15),
      tags: const ['Flutter', 'Firebase'],
    ),
    // Add more projects here
  ];
}
