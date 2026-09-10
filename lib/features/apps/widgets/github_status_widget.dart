import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/profile.dart';
import '../github/github_cubit.dart';

/// Live GitHub stats in the system chrome.
///
/// Three things were wrong with this before: it had no tap handler at all
/// despite being styled as a button, it was mounted only in the Windows
/// taskbar, and an API failure left a dead placeholder chip on screen forever.
class GithubStatusWidget extends StatelessWidget {
  /// Tint for chrome that is not dark.
  final Color foreground;

  const GithubStatusWidget({super.key, this.foreground = Colors.white});

  Future<void> _openProfile() async {
    await launchUrl(
      Uri.parse(Profile.githubUrl),
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubCubit, GithubState>(
      builder: (context, state) {
        final profile = state.profile;

        // Rate limited or offline: still a working link to the profile,
        // just without the numbers.
        final label = profile == null
            ? 'GitHub'
            : '${profile.publicRepos} repos · ${profile.followers} followers';

        return Tooltip(
          message: state.hasFailed
              ? 'Open GitHub profile (stats unavailable)'
              : 'Open GitHub profile',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _openProfile,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: foreground.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: foreground.withValues(alpha: 0.16),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code_rounded,
                      color: foreground.withValues(
                        alpha: profile == null ? 0.6 : 1,
                      ),
                      size: 15,
                    ),
                    const SizedBox(width: 7),
                    if (state.isLoading)
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: foreground.withValues(alpha: 0.6),
                        ),
                      )
                    else
                      Text(
                        label,
                        style: TextStyle(
                          color: foreground.withValues(
                            alpha: profile == null ? 0.6 : 1,
                          ),
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
