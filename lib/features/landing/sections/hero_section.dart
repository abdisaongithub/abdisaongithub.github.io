import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../../core/profile.dart';
import '../../apps/github/github_cubit.dart';
import '../widgets/copy_email_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ContentShell(
      verticalPadding: width < 600 ? AppSpacing.xxl : AppSpacing.xxxl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInUp(child: _AvailabilityPill()),
          const SizedBox(height: AppSpacing.lg),
          FadeInUp(
            delay: const Duration(milliseconds: 60),
            child: Text(
              'I build products\nend to end.',
              style: AppText.display(width),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeInUp(
            delay: const Duration(milliseconds: 120),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                '${Profile.tagline} in ${Profile.location}. I ship Flutter '
                'apps, TypeScript and Dart backends, and developer tooling — '
                'including packages published on npm and pub.dev. This whole '
                'site is a Flutter web app running six operating systems.',
                style: AppText.body.copyWith(fontSize: 17),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeInUp(
            delay: const Duration(milliseconds: 180),
            child: Wrap(
              spacing: AppSpacing.sm + 4,
              runSpacing: AppSpacing.sm + 4,
              children: [
                AppButton(
                  label: 'Hire me',
                  icon: Icons.mail_outline_rounded,
                  onPressed: () => _mailto(),
                ),
                const CopyEmailButton(),
                AppButton(
                  label: 'GitHub',
                  icon: Icons.code_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _open(Profile.githubUrl),
                ),
                AppButton(
                  label: 'LinkedIn',
                  icon: Icons.work_outline_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _open(Profile.linkedinUrl),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const FadeInUp(
            delay: Duration(milliseconds: 240),
            child: _GithubStatsBar(),
          ),
        ],
      ),
    );
  }

  static Future<void> _mailto() async {
    await launchUrl(
      Uri(
        scheme: 'mailto',
        path: Profile.email,
        query: 'subject=Role opportunity',
      ),
    );
  }

  static Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }
}

class _AvailabilityPill extends StatelessWidget {
  const _AvailabilityPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text(
            'Available for new roles',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Live numbers straight from the GitHub API. Real figures beat invented ones,
/// and they stay current without anyone editing the site.
class _GithubStatsBar extends StatelessWidget {
  const _GithubStatsBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubCubit, GithubState>(
      builder: (context, state) {
        // Rate limited or offline: show nothing rather than a row of zeroes.
        if (state.hasFailed) return const SizedBox.shrink();

        final profile = state.profile;
        final stats = <({String value, String label})>[
          (value: '${profile?.publicRepos ?? '—'}', label: 'Public repos'),
          (value: '${profile?.followers ?? '—'}', label: 'Followers'),
          (
            value: state.repos.isEmpty ? '—' : '${state.languages.length}',
            label: 'Languages',
          ),
          (value: '2', label: 'Published packages'),
        ];

        return Wrap(
          spacing: AppSpacing.xxl,
          runSpacing: AppSpacing.lg,
          children: [
            for (final stat in stats)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stat.value,
                    style: AppText.h1.copyWith(
                      fontSize: 30,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(stat.label, style: AppText.eyebrow),
                ],
              ),
          ],
        );
      },
    );
  }
}
