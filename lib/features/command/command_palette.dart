import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/design/tokens.dart';
import '../../core/design/ui.dart';
import '../../core/profile.dart';
import '../os_mode/cubit/os_mode_cubit.dart';
import '../os_mode/os_mode.dart';
import '../projects/project.dart';
import '../virtual_window/cubit/window_manager_cubit.dart';
import '../virtual_window/window_content.dart';

@immutable
class CommandAction {
  final String label;
  final String? hint;
  final IconData icon;
  final String group;
  final VoidCallback run;

  const CommandAction({
    required this.label,
    required this.icon,
    required this.group,
    required this.run,
    this.hint,
  });
}

/// Ctrl/Cmd-K launcher.
///
/// Recruiters skim; developers press Ctrl-K. This gives both a single place to
/// reach every project link, contact route and OS shell without scrolling.
class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Command palette',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: AppMotion.fast,
      pageBuilder: (context, animation, secondary) => const CommandPalette(),
      transitionBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.emphasized,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  String _query = '';
  int _selected = 0;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<CommandAction> _actionsFor(BuildContext context) {
    final osCubit = context.read<OSModeCubit>();
    final windows = context.read<WindowManagerCubit>();

    return [
      CommandAction(
        label: 'Email ${Profile.email}',
        hint: 'Contact',
        icon: Icons.mail_outline_rounded,
        group: 'Contact',
        run: () => launchUrl(
          Uri(
            scheme: 'mailto',
            path: Profile.email,
            query: 'subject=Role opportunity',
          ),
        ),
      ),
      CommandAction(
        label: 'Copy email address',
        icon: Icons.copy_rounded,
        group: 'Contact',
        run: () => Clipboard.setData(
          const ClipboardData(text: Profile.email),
        ),
      ),
      CommandAction(
        label: 'Open GitHub profile',
        icon: Icons.code_rounded,
        group: 'Contact',
        run: () => _open(Profile.githubUrl),
      ),
      CommandAction(
        label: 'Open LinkedIn',
        icon: Icons.work_outline_rounded,
        group: 'Contact',
        run: () => _open(Profile.linkedinUrl),
      ),
      for (final project in kProjects)
        for (final link in project.links)
          CommandAction(
            label: '${project.title} — ${link.displayLabel}',
            hint: project.tech.take(2).join(', '),
            icon: link.kind.icon,
            group: 'Projects',
            run: () => _open(link.url),
          ),
      for (final mode in OSMode.values)
        CommandAction(
          label: 'Boot ${mode.label}',
          hint: mode == osCubit.state.detected ? 'Your platform' : null,
          icon: mode.icon,
          group: 'Operating systems',
          // setMode only swaps shells once inside; from the landing page the
          // OS has to be entered, or nothing visible happens.
          run: () => osCubit.state.isInOS
              ? osCubit.setMode(mode)
              : osCubit.enterOS(mode),
        ),
      // On the landing page the visitor is already looking at the portfolio.
      if (osCubit.state.isInOS)
        CommandAction(
          label: 'Open portfolio',
          icon: Icons.auto_awesome_mosaic_outlined,
          group: 'Navigation',
          run: () => windows.openWindow(
            const WindowContent(
              title: 'Portfolio — Abdisa Tsegaye',
              type: WindowContentType.portfolio,
            ),
          ),
        ),
      CommandAction(
        label: 'Open terminal',
        hint: osCubit.state.isInOS ? null : 'Enters the OS',
        icon: Icons.terminal_rounded,
        group: 'Navigation',
        run: () {
          // Windows only render inside a shell; the terminal is waiting
          // there once the boot finishes.
          if (!osCubit.state.isInOS) osCubit.enterDetectedOS();
          windows.openWindow(
            const WindowContent(
              title: 'Terminal',
              type: WindowContentType.terminal,
            ),
          );
        },
      ),
    ];
  }

  List<CommandAction> _filtered(BuildContext context) {
    final actions = _actionsFor(context);
    if (_query.isEmpty) return actions;

    final query = _query.toLowerCase();
    return actions
        .where(
          (action) =>
              action.label.toLowerCase().contains(query) ||
              action.group.toLowerCase().contains(query) ||
              (action.hint?.toLowerCase().contains(query) ?? false),
        )
        .toList();
  }

  void _runSelected(List<CommandAction> actions) {
    if (actions.isEmpty) return;
    final action = actions[_selected.clamp(0, actions.length - 1)];
    Navigator.of(context).pop();
    action.run();
  }

  void _move(int delta, int length) {
    if (length == 0) return;
    setState(() => _selected = (_selected + delta) % length);
    if (_selected < 0) _selected += length;
  }

  static Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final actions = _filtered(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 460),
          child: ClipRRect(
            borderRadius: AppRadius.allLg,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              // showGeneralDialog, unlike showDialog, supplies no Material,
              // and TextField refuses to build without one.
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: AppDecoration.panel,
                  child: CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                          _move(1, actions.length),
                      const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                          _move(-1, actions.length),
                      const SingleActivator(LogicalKeyboardKey.enter): () =>
                          _runSelected(actions),
                      const SingleActivator(LogicalKeyboardKey.escape): () =>
                          Navigator.of(context).pop(),
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SearchField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: (value) => setState(() {
                            _query = value;
                            _selected = 0;
                          }),
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        Flexible(
                          child: actions.isEmpty
                              ? const _EmptyState()
                              : ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                  itemCount: actions.length,
                                  itemBuilder: (context, index) {
                                    final action = actions[index];
                                    final showGroup = index == 0 ||
                                        actions[index - 1].group !=
                                            action.group;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        if (showGroup)
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              AppSpacing.md,
                                              AppSpacing.sm + 4,
                                              AppSpacing.md,
                                              AppSpacing.xs,
                                            ),
                                            child: Text(
                                              action.group.toUpperCase(),
                                              style: AppText.eyebrow,
                                            ),
                                          ),
                                        _CommandRow(
                                          action: action,
                                          selected: index == _selected,
                                          onTap: () {
                                            setState(() => _selected = index);
                                            _runSelected(actions);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        ),
                        const _PaletteFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 18,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onChanged: onChanged,
              style: AppText.label.copyWith(fontSize: 15),
              cursorColor: AppColors.accentBright,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                hintText: 'Search projects, links, shells…',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  final CommandAction action;
  final bool selected;
  final VoidCallback onTap;

  const _CommandRow({
    required this.action,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 1,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accentSoft
              : (hovered ? AppColors.surfaceOverlay : Colors.transparent),
          borderRadius: AppRadius.allSm,
          border: Border.all(
            color: selected ? AppColors.accent : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              action.icon,
              size: 16,
              color: selected ? AppColors.accentBright : AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Text(
                action.label,
                style: AppText.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (action.hint != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                action.hint!,
                style: AppText.bodySm.copyWith(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Center(child: Text('No matches', style: AppText.bodySm)),
    );
  }
}

class _PaletteFooter extends StatelessWidget {
  const _PaletteFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _Key(label: '↑↓'),
          const SizedBox(width: 6),
          Text('navigate', style: AppText.eyebrow),
          const SizedBox(width: AppSpacing.md),
          _Key(label: '↵'),
          const SizedBox(width: 6),
          Text('open', style: AppText.eyebrow),
          const SizedBox(width: AppSpacing.md),
          _Key(label: 'esc'),
          const SizedBox(width: 6),
          Text('close', style: AppText.eyebrow),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  final String label;

  const _Key({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppText.mono.copyWith(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
