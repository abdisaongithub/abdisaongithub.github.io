class ProjectModel {
  final String title;
  final String description;
  final String techStack;
  final String? imageUrl;
  final String? link;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    this.imageUrl,
    this.link,
  });
}

const List<ProjectModel> kSampleProjects = [
  ProjectModel(
    title: 'Flutter Portfolio OS',
    description:
        'A web-based portfolio imitating various operating systems (Windows, macOS, Linux, Android, iOS).',
    techStack: 'Flutter, Dart, Bloc',
    link: 'https://github.com/abdisaongithub/flutter_portfolio_app',
  ),
  ProjectModel(
    title: 'E-Commerce App',
    description:
        'A full-featured mobile e-commerce application with payment integration.',
    techStack: 'Flutter, Firebase, Stripe',
  ),
  ProjectModel(
    title: 'Task Manager API',
    description: 'Backend API for a task management system.',
    techStack: 'Node.js, Express, MongoDB',
  ),
];
