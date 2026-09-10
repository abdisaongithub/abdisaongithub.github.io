import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../apps/app_enums.dart';
import '../apps/app_launcher_service.dart';

/// Breakpoint below which the landing page switches to a single column.
const double _kCompactWidth = 760;

class WebLauncher extends StatelessWidget {
  const WebLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < _kCompactWidth;
          final gutter = isCompact ? 20.0 : 40.0;

          return Stack(
            children: [
              // 1. Animated Mesh Gradient (Blurred Circles for effect)
              const _MeshBackground(),

              // 2. Main Content
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _WebHeader(isCompact: isCompact, gutter: gutter),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: gutter,
                      vertical: isCompact ? 32 : 60,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _HeroSection(maxWidth: constraints.maxWidth),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    sliver: const SliverToBoxAdapter(
                      child: _SectionHeader(title: 'Projects'),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: gutter,
                      vertical: 20,
                    ),
                    sliver: _ProjectsGrid(isCompact: isCompact),
                  ),
                  // Space for the floating dock
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),

              // 3. Floating Glass Dock
              const Align(
                alignment: Alignment.bottomCenter,
                child: _WebDock(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MeshBackground extends StatelessWidget {
  const _MeshBackground();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _PulseCircle(
              color: Colors.blue.withValues(alpha: 0.2),
              size: 400,
            ),
          ),
          Positioned(
            bottom: -150,
            left: -50,
            child: _PulseCircle(
              color: Colors.purple.withValues(alpha: 0.2),
              size: 500,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _PulseCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _WebHeader extends StatelessWidget {
  final bool isCompact;
  final double gutter;

  const _WebHeader({required this.isCompact, required this.gutter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(gutter, gutter, gutter, isCompact ? 8 : 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            child: Text(
              'ABDISA.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // The nav links do not fit beside the wordmark on a phone.
          if (!isCompact)
            const Row(
              children: [
                _HeaderLink('About'),
                SizedBox(width: 30),
                _HeaderLink('Work'),
                SizedBox(width: 30),
                _HeaderLink('Contact'),
              ],
            )
          else
            _HeaderIconButton(
              icon: Icons.mail_outline,
              tooltip: 'Contact',
              onTap: () => AppLauncherService.launch(context, AppType.email),
            ),
        ],
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  final String text;

  const _HeaderLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white70, size: 20),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }
}

class _HeroSection extends StatelessWidget {
  final double maxWidth;

  const _HeroSection({required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    // The headline used to be a hard 64px, which blew past a phone viewport.
    final headlineSize =
        maxWidth < 480 ? 34.0 : (maxWidth < _kCompactWidth ? 44.0 : 64.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
          ),
          child: const Text(
            'AVAILABLE FOR WORK',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Designing Digital\nExperiences that Matter.',
          style: TextStyle(
            color: Colors.white,
            fontSize: headlineSize,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: const Text(
            'I build high-fidelity interactive interfaces across Windows, '
            'macOS, Linux, and Mobile. Specializing in Glassmorphism and '
            'immersive digital environments.',
            style: TextStyle(color: Colors.white60, fontSize: 17, height: 1.6),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white30,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final bool isCompact;

  const _ProjectsGrid({required this.isCompact});

  static const _projects = [
    (
      title: 'OS Portfolio Orbit',
      category: 'Product Design',
      color: Colors.blue,
    ),
    (
      title: 'Glassmorphic Dash',
      category: 'UI/UX Design',
      color: Colors.purple,
    ),
    (
      title: 'Mobile OS Sim',
      category: 'Interactive Dev',
      color: Colors.orange,
    ),
    (
      title: 'Mesh Gradient Engine',
      category: 'Visual Art',
      color: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Two columns never fit on a phone.
        crossAxisCount: isCompact ? 1 : 2,
        mainAxisSpacing: isCompact ? 20 : 30,
        crossAxisSpacing: 30,
        childAspectRatio: isCompact ? 1.7 : 1.5,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final project = _projects[index];
        return _ProjectCard(
          title: project.title,
          category: project.category,
          color: project.color,
          isCompact: isCompact,
        );
      }, childCount: _projects.length),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String category;
  final Color color;
  final bool isCompact;

  const _ProjectCard({
    required this.title,
    required this.category,
    required this.color,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 20,
            right: 20,
            child: Icon(Icons.north_east, color: Colors.white30, size: 20),
          ),
          Padding(
            padding: EdgeInsets.all(isCompact ? 22.0 : 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WebDock extends StatelessWidget {
  const _WebDock();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(40);

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: radius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DockIcon(
                  icon: Icons.grid_view_rounded,
                  tooltip: 'Projects',
                  onTap: () =>
                      AppLauncherService.launch(context, AppType.projects),
                ),
                _DockIcon(
                  icon: Icons.person_rounded,
                  tooltip: 'About',
                  onTap: () => AppLauncherService.launch(context, AppType.cv),
                ),
                _DockIcon(
                  icon: Icons.code_rounded,
                  tooltip: 'GitHub',
                  onTap: () =>
                      AppLauncherService.launch(context, AppType.github),
                ),
                _DockIcon(
                  icon: Icons.mail_rounded,
                  tooltip: 'Contact',
                  onTap: () =>
                      AppLauncherService.launch(context, AppType.email),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _DockIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Colors.white70, size: 22),
        onPressed: onTap,
      ),
    );
  }
}
