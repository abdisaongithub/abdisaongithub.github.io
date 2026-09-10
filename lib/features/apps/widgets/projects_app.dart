import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../projects/project.dart';
import '../media/video_embed.dart';

/// The Projects app.
///
/// Opening "Projects" used to launch a virtual-filesystem browser showing
/// manifest.json files, which told a visitor nothing. This shows the actual
/// work, reusing the same project data as the landing page.
class ProjectsApp extends StatefulWidget {
  const ProjectsApp({super.key});

  @override
  State<ProjectsApp> createState() => _ProjectsAppState();
}

class _ProjectsAppState extends State<ProjectsApp> {
  String? _selectedId;

  Project? get _selected {
    if (_selectedId == null) return null;
    for (final project in kProjects) {
      if (project.id == _selectedId) return project;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return ColoredBox(
      color: AppColors.bg,
      child: selected == null
          ? _ProjectGrid(onSelect: (id) => setState(() => _selectedId = id))
          : _ProjectDetail(
              project: selected,
              onBack: () => setState(() => _selectedId = null),
            ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const _ProjectGrid({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 560 ? 1 : 2;
        const gap = AppSpacing.md;
        final cardWidth =
            (constraints.maxWidth - AppSpacing.lg * 2 - gap * (columns - 1)) /
                columns;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${kProjects.length} PROJECTS', style: AppText.eyebrow),
              const SizedBox(height: AppSpacing.xs),
              const Text('Selected work', style: AppText.h2),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final project in kProjects)
                    SizedBox(
                      width: cardWidth,
                      child: _MiniCard(
                        project: project,
                        onTap: () => onSelect(project.id),
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

class _MiniCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _MiniCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: AppDecoration.card(hovered: hovered),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: project.accent.withValues(alpha: 0.12),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Icon(project.icon, size: 15, color: project.accent),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Text(
                    project.title,
                    style: AppText.label.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 17,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm + 2),
            Text(
              project.summary,
              style: AppText.bodySm.copyWith(fontSize: 12.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  final Project project;
  final VoidCallback onBack;

  const _ProjectDetail({required this.project, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButton(
            label: 'All projects',
            icon: Icons.arrow_back_rounded,
            variant: AppButtonVariant.ghost,
            dense: true,
            onPressed: onBack,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: project.accent.withValues(alpha: 0.12),
                  borderRadius: AppRadius.allMd,
                ),
                child: Icon(project.icon, size: 22, color: project.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(project.title, style: AppText.h2)),
            ],
          ),
          if (project.badge != null) ...[
            const SizedBox(height: AppSpacing.md),
            AppChip(
              label: project.badge!,
              accent: project.accent,
              icon: Icons.verified_outlined,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(project.description, style: AppText.body),
          // A demo appears automatically once a videoId is set on the project.
          if (project.videoId != null) ...[
            const SizedBox(height: AppSpacing.lg),
            VideoEmbed(videoId: project.videoId!, title: project.title),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('STACK', style: AppText.eyebrow),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final tech in project.tech) AppChip(label: tech)],
          ),
          const SizedBox(height: AppSpacing.lg),
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
  }
}
