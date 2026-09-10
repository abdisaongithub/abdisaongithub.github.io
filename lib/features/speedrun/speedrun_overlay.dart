import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/tokens.dart';
import '../../core/design/ui.dart';
import 'speedrun_cubit.dart';

/// The speedrun HUD and its invitation card.
///
/// Deliberately non-modal: it never blocks the UI, and "Take over" stops the
/// tour instantly and leaves everything on screen where it is.
class SpeedrunOverlay extends StatelessWidget {
  const SpeedrunOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeedrunCubit, SpeedrunState>(
      builder: (context, state) {
        final child = switch (state.status) {
          SpeedrunStatus.offered => const _Invitation(),
          SpeedrunStatus.running => _RunningHud(state: state),
          _ => const SizedBox.shrink(),
        };

        return Positioned(
          left: 24,
          bottom: 24,
          child: AnimatedSwitcher(
            duration: AppMotion.normal,
            switchInCurve: AppMotion.emphasized,
            child: child,
          ),
        );
      },
    );
  }
}

class _Invitation extends StatelessWidget {
  const _Invitation();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 15,
                color: AppColors.accentBright,
              ),
              const SizedBox(width: 6),
              Text('FIRST TIME HERE?', style: AppText.eyebrow),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const SizedBox(
            width: 240,
            child: Text(
              'Watch a 30-second tour of what this thing can do.',
              style: AppText.bodySm,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppButton(
                label: 'Start tour',
                icon: Icons.play_arrow_rounded,
                dense: true,
                onPressed: () => context.read<SpeedrunCubit>().start(),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'No thanks',
                variant: AppButtonVariant.ghost,
                dense: true,
                onPressed: () => context.read<SpeedrunCubit>().dismiss(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RunningHud extends StatelessWidget {
  final SpeedrunState state;

  const _RunningHud({required this.state});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                size: 15,
                color: AppColors.accentBright,
              ),
              const SizedBox(width: 6),
              Text(
                '${state.step + 1} / ${state.total}',
                style: AppText.mono.copyWith(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 190,
                child: Text(
                  state.label,
                  style: AppText.label.copyWith(fontSize: 12.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              width: 268,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: state.progress),
                duration: AppMotion.normal,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 3,
                  backgroundColor: AppColors.surfaceOverlay,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accentBright,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppButton(
                label: 'Take over',
                icon: Icons.pan_tool_alt_outlined,
                variant: AppButtonVariant.secondary,
                dense: true,
                onPressed: () => context.read<SpeedrunCubit>().takeOver(),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Skip',
                variant: AppButtonVariant.ghost,
                dense: true,
                onPressed: () => context.read<SpeedrunCubit>().takeOver(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;

  const _Panel({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.allLg,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.88),
            borderRadius: AppRadius.allLg,
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
