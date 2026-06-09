import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class WebLauncher extends StatelessWidget {
  const WebLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // 1. Animated Mesh Gradient (Blurred Circles for effect)
          const _MeshBackground(),

          // 2. Main Content
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _WebHeader()),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                sliver: SliverToBoxAdapter(child: _HeroSection()),
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                sliver: SliverToBoxAdapter(
                    child: _SectionHeader(title: 'Projects')),
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                sliver: _ProjectsGrid(),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: 120)), // Space for dock
            ],
          ),

          // 3. Floating Glass Dock
          const Align(
            alignment: Alignment.bottomCenter,
            child: _WebDock(),
          ),
        ],
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
            child: _PulseCircle(color: Colors.blue.withOpacity(0.2), size: 400),
          ),
          Positioned(
            bottom: -150,
            left: -50,
            child:
                _PulseCircle(color: Colors.purple.withOpacity(0.2), size: 500),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                  sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  const _WebHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'ABDISA.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          Row(
            children: [
              _headerLink('About'),
              const SizedBox(width: 30),
              _headerLink('Work'),
              const SizedBox(width: 30),
              _headerLink('Contact'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerLink(String text) {
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

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: const Text(
            'AVAILABLE FOR WORK',
            style: TextStyle(
                color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Designing Digital\nExperiences that Matter.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 24),
        const SizedBox(
          width: 600,
          child: Text(
            'I build high-fidelity interactive interfaces across Windows, macOS, Linux, and Mobile. Specializing in Glassmorphism and immersive digital environments.',
            style: TextStyle(color: Colors.white60, fontSize: 18, height: 1.6),
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
  const _ProjectsGrid();

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildListDelegate([
        const _ProjectCard(
            title: 'OS Portfolio Orbit',
            category: 'Product Design',
            color: Colors.blue),
        const _ProjectCard(
            title: 'Glassmorphic Dash',
            category: 'UI/UX Design',
            color: Colors.purple),
        const _ProjectCard(
            title: 'Mobile OS Sim',
            category: 'Interactive Dev',
            color: Colors.orange),
        const _ProjectCard(
            title: 'Mesh Gradient Engine',
            category: 'Visual Art',
            color: Colors.teal),
      ]),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String category;
  final Color color;

  const _ProjectCard(
      {required this.title, required this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Icon(Icons.north_east, color: Colors.white30, size: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(category.toUpperCase(),
                    style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DockIcon(Icons.home_filled),
                _DockIcon(Icons.grid_view_rounded),
                _DockIcon(Icons.person_rounded),
                _DockIcon(Icons.mail_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _DockIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Icon(icon, color: Colors.white70, size: 24),
    );
  }
}
