import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../landing/sections/contact_section.dart';
import '../../landing/sections/hero_section.dart';
import '../../landing/sections/projects_section.dart';
import '../../landing/sections/skills_section.dart';

/// The portfolio, as an app window.
///
/// The site boots straight into an OS shell, so this is where the actual
/// hiring content lives. It opens automatically on first load — the work must
/// not be something a visitor has to go looking for.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              HeroSection(),
              ProjectsSection(),
              SkillsSection(),
              ContactSection(),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
