import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../projects/project.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 720 ? 1 : (width < 1080 ? 2 : 3);

    return ContentShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Work',
            title: 'Selected projects',
            subtitle:
                'Real repositories, with source you can read and packages you '
                'can install.',
          ),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final project in kProjects)
                    SizedBox(
                      width: cardWidth,
                      child: ProjectCard(project: project),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovered) {
        return AnimatedContainer(
          duration: AppMotion.fast,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecoration.card(hovered: hovered),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: project.accent.withValues(alpha: 0.12),
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Icon(project.icon, size: 18, color: project.accent),
                  ),
                  const SizedBox(width: AppSpacing.sm + 4),
                  Expanded(
                    child: Text(
                      project.title,
                      style: AppText.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (project.badge != null) ...[
                const SizedBox(height: AppSpacing.sm + 4),
                AppChip(
                  label: project.badge!,
                  accent: project.accent,
                  icon: Icons.verified_outlined,
                ),
              ],
              const SizedBox(height: AppSpacing.sm + 4),
              Text(project.summary, style: AppText.bodySm),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final tech in project.tech) AppChip(label: tech),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final link in project.links)
                    AppButton(
                      label: link.displayLabel,
                      icon: link.kind.icon,
                      variant: AppButtonVariant.secondary,
                      dense: true,
                      onPressed: () => launchUrl(
                        Uri.parse(link.url),
                        webOnlyWindowName: '_blank',
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
