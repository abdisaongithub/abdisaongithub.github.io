import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../os_mode/cubit/os_mode_cubit.dart';
import '../../os_mode/os_mode.dart';

/// Sells the OS simulator instead of forcing visitors through it.
///
/// The desktop shells are the most technically interesting thing here, but as
/// a landing experience they buried the content. Now they are an invitation.
class OsTeaserSection extends StatelessWidget {
  const OsTeaserSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 860;

    return ContentShell(
      child: Container(
        padding: EdgeInsets.all(isCompact ? AppSpacing.lg : AppSpacing.xxl),
        decoration: BoxDecoration(
          borderRadius: AppRadius.allXl,
          border: Border.all(color: AppColors.border),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent.withValues(alpha: 0.16),
              AppColors.surface,
            ],
          ),
        ),
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
                    eyebrow: 'The fun part',
                    title: 'This site is an operating system',
                    subtitle:
                        'Six shells — Windows, macOS, Ubuntu, Android, iOS — '
                        'sharing one window manager with real dragging, '
                        'resizing, maximizing and z-ordering, a virtual '
                        'filesystem and a working terminal. It detects your '
                        'platform and boots the one you actually use.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<OSModeCubit, OSModeState>(
                    builder: (context, state) {
                      return Wrap(
                        spacing: AppSpacing.sm + 4,
                        runSpacing: AppSpacing.sm + 4,
                        children: [
                          AppButton(
                            label: 'Boot ${state.detected.label}',
                            icon: Icons.play_arrow_rounded,
                            onPressed: () =>
                                context.read<OSModeCubit>().enterDetectedOS(),
                          ),
                          AppButton(
                            label: 'Open terminal',
                            icon: Icons.terminal_rounded,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => context
                                .read<OSModeCubit>()
                                .enterOS(state.detected),
                          ),
                        ],
                      );
                    },
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
              child: const _ShellList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShellList extends StatelessWidget {
  const _ShellList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OSModeCubit, OSModeState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in OSMode.values)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Hoverable(
                  onTap: () => context.read<OSModeCubit>().enterOS(mode),
                  builder: (context, hovered) => AnimatedContainer(
                    duration: AppMotion.fast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: hovered
                          ? AppColors.surfaceOverlay
                          : AppColors.surface.withValues(alpha: 0.6),
                      borderRadius: AppRadius.allMd,
                      border: Border.all(
                        color:
                            hovered ? AppColors.borderStrong : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          mode.icon,
                          size: 17,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm + 4),
                        Expanded(
                          child: Text(mode.label, style: AppText.label),
                        ),
                        if (state.detected == mode)
                          const AppChip(
                            label: 'Your OS',
                            accent: AppColors.success,
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: AppColors.textTertiary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
