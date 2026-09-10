import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/ui.dart';
import '../../../core/profile.dart';

/// Copies the email address to the clipboard.
///
/// A plain mailto: link is a dead end for anyone on webmail — it either opens
/// nothing or launches a mail client they never use. Offering the raw address
/// as one click removes that failure mode.
class CopyEmailButton extends StatefulWidget {
  const CopyEmailButton({super.key});

  @override
  State<CopyEmailButton> createState() => _CopyEmailButtonState();
}

class _CopyEmailButtonState extends State<CopyEmailButton> {
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
      label: _copied ? 'Copied!' : Profile.email,
      icon: _copied ? Icons.check_rounded : Icons.copy_rounded,
      variant: AppButtonVariant.secondary,
      onPressed: _copy,
    );
  }
}
