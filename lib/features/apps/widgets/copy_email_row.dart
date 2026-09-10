import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/ui.dart';
import '../../../core/profile.dart';

/// Copy-to-clipboard email button for in-OS apps.
class CopyEmailRow extends StatefulWidget {
  const CopyEmailRow({super.key});

  @override
  State<CopyEmailRow> createState() => _CopyEmailRowState();
}

class _CopyEmailRowState extends State<CopyEmailRow> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: Profile.email));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: _copied ? 'Copied!' : 'Copy email',
      icon: _copied ? Icons.check_rounded : Icons.copy_rounded,
      variant: AppButtonVariant.secondary,
      dense: true,
      onPressed: _copy,
    );
  }
}
