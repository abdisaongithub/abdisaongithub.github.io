import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../../core/profile.dart';
import '../../apps/now_playing/spotify_player.dart';
import '../widgets/copy_email_button.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 860;

    return ContentShell(
      child: Flex(
        direction: isCompact ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isCompact ? 0 : 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SectionHeading(
                  eyebrow: 'Contact',
                  title: 'Let us build something',
                  subtitle:
                      'Open to full-time roles, contract work and interesting '
                      'problems. The fastest way to reach me is email — I '
                      'reply to everything.',
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.sm + 4,
                  runSpacing: AppSpacing.sm + 4,
                  children: [
                    AppButton(
                      label: 'Email me',
                      icon: Icons.mail_outline_rounded,
                      onPressed: () => launchUrl(
                        Uri(
                          scheme: 'mailto',
                          path: Profile.email,
                          query: 'subject=Role opportunity',
                        ),
                      ),
                    ),
                    const CopyEmailButton(),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm + 4,
                  runSpacing: AppSpacing.sm + 4,
                  children: [
                    AppButton(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      variant: AppButtonVariant.secondary,
                      dense: true,
                      onPressed: () => _open(Profile.githubUrl),
                    ),
                    AppButton(
                      label: 'LinkedIn',
                      icon: Icons.work_outline_rounded,
                      variant: AppButtonVariant.secondary,
                      dense: true,
                      onPressed: () => _open(Profile.linkedinUrl),
                    ),
                    AppButton(
                      label: Profile.phoneDisplay,
                      icon: Icons.call_outlined,
                      variant: AppButtonVariant.secondary,
                      dense: true,
                      onPressed: () =>
                          launchUrl(Uri(scheme: 'tel', path: Profile.phone)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: isCompact ? 0 : AppSpacing.xxl,
            height: isCompact ? AppSpacing.xl : 0,
          ),
          Expanded(
            flex: isCompact ? 0 : 2,
            child: const _NowPlayingCard(),
          ),
        ],
      ),
    );
  }

  static Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }
}

/// A small personal note. Real Spotify playback, not a mock.
class _NowPlayingCard extends StatelessWidget {
  const _NowPlayingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecoration.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                size: 16,
                color: AppColors.spotify,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('ON REPEAT WHILE I BUILD', style: AppText.eyebrow),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const SpotifyPlayer(),
        ],
      ),
    );
  }
}
