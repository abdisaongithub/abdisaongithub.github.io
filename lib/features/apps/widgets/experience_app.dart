import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../../core/profile.dart';
import '../../projects/project.dart';
import 'copy_email_row.dart';

/// The CV app.
///
/// The employment history below is still placeholder — swap `kExperience` for
/// real roles when you have them.
class ExperienceApp extends StatelessWidget {
  const ExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppSpacing.lg),
            Text('EXPERIENCE', style: AppText.eyebrow),
            const SizedBox(height: AppSpacing.md),
            for (final role in kExperience) _TimelineItem(role: role),
            const SizedBox(height: AppSpacing.md),
            Text('SKILLS', style: AppText.eyebrow),
            const SizedBox(height: AppSpacing.md),
            for (final group in kSkills.entries) ...[
              Text(
                group.key,
                style: AppText.bodySm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final skill in group.value) AppChip(label: skill),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: AppRadius.allMd,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.accentBright,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(Profile.name, style: AppText.h2),
                  const SizedBox(height: 2),
                  Text(
                    '${Profile.tagline} · ${Profile.location}',
                    style: AppText.bodySm,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              dense: true,
              onPressed: () => launchUrl(
                Uri(
                  scheme: 'mailto',
                  path: Profile.email,
                  query: 'subject=Role opportunity',
                ),
              ),
            ),
            const CopyEmailRow(),
            AppButton(
              label: 'GitHub',
              icon: Icons.code_rounded,
              variant: AppButtonVariant.secondary,
              dense: true,
              onPressed: () => launchUrl(
                Uri.parse(Profile.githubUrl),
                webOnlyWindowName: '_blank',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Role role;

  const _TimelineItem({required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(role.title, style: AppText.h3),
                const SizedBox(height: 2),
                Text(
                  '${role.company} · ${role.period}',
                  style: AppText.bodySm.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(role.description, style: AppText.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class Role {
  final String period;
  final String title;
  final String company;
  final String description;

  const Role({
    required this.period,
    required this.title,
    required this.company,
    required this.description,
  });
}

/// PLACEHOLDER — replace with real roles.
const List<Role> kExperience = [
  Role(
    period: '2024 — Present',
    title: 'Senior Flutter Developer',
    company: 'Placeholder',
    description:
        'Placeholder entry. Replace kExperience in experience_app.dart with '
        'real roles, dates and outcomes.',
  ),
  Role(
    period: '2022 — 2024',
    title: 'Mobile App Developer',
    company: 'Placeholder',
    description:
        'Placeholder entry. Replace kExperience in experience_app.dart with '
        'real roles, dates and outcomes.',
  ),
];
