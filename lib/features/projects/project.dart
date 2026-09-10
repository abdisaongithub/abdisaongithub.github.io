import 'package:flutter/material.dart';

/// A link attached to a project. Kept explicit so a card can render the right
/// icon and label rather than guessing from the URL.
enum ProjectLinkKind { repo, live, npm, pub, demo }

extension ProjectLinkKindInfo on ProjectLinkKind {
  String get label {
    switch (this) {
      case ProjectLinkKind.repo:
        return 'Source';
      case ProjectLinkKind.live:
        return 'Live';
      case ProjectLinkKind.npm:
        return 'npm';
      case ProjectLinkKind.pub:
        return 'pub.dev';
      case ProjectLinkKind.demo:
        return 'Demo';
    }
  }

  IconData get icon {
    switch (this) {
      case ProjectLinkKind.repo:
        return Icons.code_rounded;
      case ProjectLinkKind.live:
        return Icons.open_in_new_rounded;
      case ProjectLinkKind.npm:
      case ProjectLinkKind.pub:
        return Icons.inventory_2_outlined;
      case ProjectLinkKind.demo:
        return Icons.play_circle_outline_rounded;
    }
  }
}

@immutable
class ProjectLink {
  final ProjectLinkKind kind;
  final String url;

  /// Overrides [ProjectLinkKind.label] — e.g. "npm v1.1.0".
  final String? label;

  const ProjectLink(this.kind, this.url, {this.label});

  String get displayLabel => label ?? kind.label;
}

@immutable
class Project {
  final String id;
  final String title;

  /// One line. This is what a recruiter actually reads.
  final String summary;

  /// Two or three sentences shown on the detail view.
  final String description;

  final List<String> tech;
  final List<ProjectLink> links;
  final Color accent;
  final IconData icon;

  /// Featured projects lead the grid.
  final bool featured;

  /// YouTube video id for a demo reel. Add one and the project gains a
  /// "Demo" tab plus an entry in the Showreel app.
  final String? videoId;

  /// Short badge, e.g. "Published on npm".
  final String? badge;

  const Project({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.tech,
    required this.links,
    required this.accent,
    required this.icon,
    this.featured = false,
    this.videoId,
    this.badge,
  });
}

/// ============================================================================
/// EDIT THIS LIST TO CURATE YOUR PROJECTS.
/// ============================================================================
/// This is the single source of truth for everything project-shaped on the
/// site: the landing grid, the Projects app, the command palette and the
/// Showreel. Add, remove or reorder entries here and every surface follows.
///
/// Each entry needs: id, title, summary (one line — this is what a recruiter
/// actually reads), description, tech, links, accent, icon. Optional:
/// `featured: true` to lead the grid, `badge` for a credential, and `videoId`
/// with a YouTube id to attach a demo.
///
/// The entries below are an interim set drawn from the public repositories,
/// with details taken from each README and verified against npm and pub.dev.
/// The site previously shipped three invented projects, which is the worst
/// possible thing for a portfolio to be caught doing.
const List<Project> kProjects = [
  Project(
    id: 'serverpod-sentinel',
    title: 'Serverpod Sentinel',
    summary:
        'Monitoring and incident-management platform for distributed systems.',
    description:
        'Real-time observability with root-cause analysis and autonomous '
        'remediation, built for high-scale backend environments. Serverpod '
        'powers the backend and a Flutter client drives the dashboards, so the '
        'whole stack is Dart end to end.',
    tech: ['Dart', 'Serverpod', 'Flutter', 'PostgreSQL'],
    links: [
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/serverpod_sentinel',
      ),
    ],
    accent: Color(0xFF6E56CF),
    icon: Icons.monitor_heart_outlined,
    featured: true,
  ),
  Project(
    id: 'school-saas',
    title: 'School SaaS',
    summary:
        'Multi-tenant school management platform — academics, admin, finance.',
    description:
        'A multi-tenant system covering administrative, academic and financial '
        'operations for schools. Tenant isolation, role-based access and '
        'reporting across a TypeScript stack.',
    tech: ['TypeScript', 'Node.js', 'Multi-tenancy', 'PostgreSQL'],
    links: [
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/school_saas',
      ),
    ],
    accent: Color(0xFF2E7DD1),
    icon: Icons.school_outlined,
    featured: true,
  ),
  Project(
    id: 'express-multipart-parser',
    title: 'express-multipart-parser',
    summary:
        'Zero-dependency Express middleware for multipart/form-data. On npm.',
    description:
        'Parses multipart/form-data into req.body and req.files, streaming file '
        'uploads rather than buffering them. Zero runtime dependencies, written '
        'in TypeScript, MIT licensed.',
    tech: ['TypeScript', 'Express', 'Node.js', 'Streams'],
    links: [
      ProjectLink(
        ProjectLinkKind.npm,
        'https://www.npmjs.com/package/express-multipart-parser',
        label: 'npm v1.1.0',
      ),
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/express-multipart-parser',
      ),
    ],
    accent: Color(0xFFCB3837),
    icon: Icons.inventory_2_outlined,
    featured: true,
    badge: 'Published on npm',
  ),
  Project(
    id: 'icon-generator',
    title: 'icon_generator',
    summary:
        'CLI that turns a folder of SVGs into an icon font plus a Dart class.',
    description:
        'Converts *.svg icons into a .ttf icon font and generates the matching '
        'Flutter-compatible Dart class, so icons stay in sync with code. '
        'Published on pub.dev and used in Flutter projects.',
    tech: ['Dart', 'CLI', 'Font tooling', 'Flutter'],
    links: [
      ProjectLink(
        ProjectLinkKind.pub,
        'https://pub.dev/packages/icon_generator',
        label: 'pub.dev v4.0.3',
      ),
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/icon_generator',
      ),
    ],
    accent: Color(0xFF3DD68C),
    icon: Icons.auto_awesome_outlined,
    featured: true,
    badge: 'Published on pub.dev',
  ),
  Project(
    id: 'google-maps-scraper',
    title: 'Google Maps Extractor',
    summary: 'Chrome extension that extracts structured data from Google Maps.',
    description:
        'A Chrome extension for pulling business listings off Google Maps into '
        'structured, exportable data — built for lead research workflows.',
    tech: ['Python', 'Chrome Extension', 'Scraping', 'JavaScript'],
    links: [
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/google_maps_scraper',
      ),
    ],
    accent: Color(0xFFFFB224),
    icon: Icons.travel_explore_outlined,
  ),
  Project(
    id: 'fon-tonic',
    title: 'Fon Tonic',
    summary: 'Mobile client for an AI chat assistant in the Fon language.',
    description:
        'A Flutter client for the Fon language AI chat application, bringing '
        'conversational AI to a language that is badly under-served by '
        'mainstream tooling.',
    tech: ['Flutter', 'Dart', 'AI', 'i18n'],
    links: [
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/fon_tonic_mobile',
      ),
    ],
    accent: Color(0xFFB44DBF),
    icon: Icons.translate_outlined,
  ),
  Project(
    id: 'portfolio-os',
    title: 'Portfolio OS',
    summary:
        'This site — a browser-based OS with a real window manager and shell.',
    description:
        'Six operating-system shells in one Flutter web app, sharing a window '
        'manager with drag, resize, maximize and z-ordering, a virtual '
        'filesystem, and a working terminal. Platform detection routes each '
        'visitor to the shell that matches their own machine.',
    tech: ['Flutter', 'Dart', 'Bloc', 'Web'],
    links: [
      ProjectLink(
        ProjectLinkKind.repo,
        'https://github.com/abdisaongithub/abdisaongithub.github.io',
      ),
      ProjectLink(ProjectLinkKind.live, 'https://abdisaongithub.github.io/'),
    ],
    accent: Color(0xFF9E8CFC),
    icon: Icons.desktop_windows_outlined,
  ),
];

List<Project> get kFeaturedProjects =>
    kProjects.where((p) => p.featured).toList();

/// Projects that have a demo video attached. Add a [Project.videoId] and the
/// Showreel app picks it up automatically.
List<Project> get kProjectsWithVideo =>
    kProjects.where((p) => p.videoId != null).toList();

/// Skills, grouped the way an interviewer would ask about them.
const Map<String, List<String>> kSkills = {
  'Languages': ['Dart', 'TypeScript', 'JavaScript', 'Python', 'PHP', 'Shell'],
  'Mobile & Frontend': [
    'Flutter',
    'Bloc / Cubit',
    'Riverpod',
    'React',
    'Responsive UI',
    'Animations',
  ],
  'Backend': [
    'Serverpod',
    'Node.js',
    'Express',
    'REST APIs',
    'PostgreSQL',
    'MongoDB',
  ],
  'Practice': [
    'Testing',
    'CI/CD',
    'GitHub Actions',
    'Docker',
    'Multi-tenancy',
    'Package publishing',
  ],
};
