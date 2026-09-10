import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/ui.dart';
import '../../projects/project.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 720 ? 1 : (width < 1080 ? 2 : 4);

    return ContentShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(eyebrow: 'Toolkit', title: 'What I work with'),
          const SizedBox(height: AppSpacing.xl),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = AppSpacing.lg;
              final columnWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;

              return Wrap(
                spacing: gap,
                runSpacing: AppSpacing.xl,
                children: [
                  for (final group in kSkills.entries)
                    SizedBox(
                      width: columnWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(group.key.toUpperCase(), style: AppText.eyebrow),
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final skill in group.value)
                                AppChip(label: skill),
                            ],
                          ),
                        ],
                      ),
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
