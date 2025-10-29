import 'package:flutter/material.dart';
import 'package:countdown_app/l10n/app_localizations.dart';

class FreeCapBanner extends StatelessWidget {
  final VoidCallback onUpgrade;
  final int current;
  final int cap;

  const FreeCapBanner({
    super.key,
    required this.onUpgrade,
    required this.current,
    required this.cap,
  });

  @override
  Widget build(BuildContext context) {
    final atCap = current >= cap;
    final remaining = cap - current;
    final l10n = AppLocalizations.of(context)!;
    final text = atCap
        ? l10n.freeCapBannerAtLimit(cap)
        : l10n.freeCapBannerRemaining(remaining);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onUpgrade,
            child: Text(l10n.freeCapBannerUpgrade),
          ),
        ],
      ),
    );
  }
}
