import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../../core/profile.dart';
import '../../command/command_palette.dart';
import '../../guide/guide_cubit.dart';
import '../../guide/guide_pulse.dart';
import '../../os_mode/cubit/os_mode_cubit.dart';

class LandingNav extends StatelessWidget {
  final VoidCallback onWork;
  final VoidCallback onSkills;
  final VoidCallback onContact;

  const LandingNav({
    super.key,
    required this.onWork,
    required this.onSkills,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 820;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg.withValues(alpha: 0.72),
            border: const Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter(width),
            vertical: AppSpacing.md,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Row(
                children: [
                  Text(
                    Profile.name,
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  if (!isCompact) ...[
                    AppButton(
                      label: 'Work',
                      onPressed: onWork,
                      variant: AppButtonVariant.ghost,
                      dense: true,
                    ),
                    AppButton(
                      label: 'Skills',
                      onPressed: onSkills,
                      variant: AppButtonVariant.ghost,
                      dense: true,
                    ),
                    AppButton(
                      label: 'Contact',
                      onPressed: onContact,
                      variant: AppButtonVariant.ghost,
                      dense: true,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const _CommandHint(),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  // A quiet ripple until the visitor has been inside once.
                  BlocSelector<GuideCubit, GuideState, bool>(
                    selector: (state) => !state.osGuideSeen,
                    builder: (context, isNew) => GuidePulse(
                      active: isNew,
                      child: AppButton(
                        label: isCompact ? 'OS' : 'Enter the OS',
                        icon: Icons.terminal_rounded,
                        dense: true,
                        onPressed: () =>
                            context.read<OSModeCubit>().enterDetectedOS(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Advertises the command palette. Discoverability is the whole reason this
/// exists — a shortcut nobody knows about may as well not ship.
class _CommandHint extends StatelessWidget {
  const _CommandHint();

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: () => CommandPalette.show(context),
      builder: (context, hovered) => AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: hovered ? AppColors.surfaceOverlay : AppColors.surface,
          borderRadius: AppRadius.allSm,
          border: Border.all(
            color: hovered ? AppColors.borderStrong : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_rounded,
              size: 14,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              'Ctrl K',
              style: AppText.mono.copyWith(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
