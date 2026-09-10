import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';
import '../../core/design/ui.dart';
import '../../core/profile.dart';
import 'sections/contact_section.dart';
import 'sections/hero_section.dart';
import 'sections/os_teaser_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'widgets/landing_nav.dart';

/// The default surface. A recruiter reaches real content immediately instead
/// of sitting through a BIOS animation and a login screen first.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollController = ScrollController();

  final _workKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: AppMotion.slow,
      curve: AppMotion.emphasized,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: MeshBackdrop(),
            ),
          ),
          Positioned.fill(
            child: SelectionArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 76),
                    const HeroSection(),
                    ProjectsSection(key: _workKey),
                    SkillsSection(key: _skillsKey),
                    const OsTeaserSection(),
                    ContactSection(key: _contactKey),
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingNav(
              onWork: () => _scrollTo(_workKey),
              onSkills: () => _scrollTo(_skillsKey),
              onContact: () => _scrollTo(_contactKey),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: ContentShell(
        verticalPadding: AppSpacing.xl,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '© ${DateTime.now().year} ${Profile.name}',
              style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
            ),
            Text(
              'Built with Flutter — source on GitHub',
              style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
