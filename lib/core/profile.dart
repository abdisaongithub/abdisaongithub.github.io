/// Single source of truth for personal / contact details.
///
/// These were previously duplicated across `app_launcher_service.dart` and
/// `terminal_app.dart`, which had drifted to different email addresses.
class Profile {
  const Profile._();

  static const String name = 'Abdisa Tsegaye';
  static const String tagline = 'Flutter Developer';
  static const String username = 'abdisaongithub';

  static const String email = 'abdtsegaye@gmail.com';
  static const String phone = '+251911364379';
  static const String phoneDisplay = '+251 911 364 379';

  static const String githubUrl = 'https://github.com/$username';
  static const String linkedinUrl = 'https://linkedin.com/in/abdisa-tsegaye';
  static const String liveUrl = 'https://abdisaongithub.github.io/';

  /// GitHub serves an avatar for every account at `<profile>.png`, which
  /// removes the need for a bundled `profile.jpg` asset that never existed.
  static const String avatarUrl = 'https://github.com/$username.png';
}
