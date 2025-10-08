import 'package:flutter/material.dart';

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
    final text = atCap
        ? 'You’ve reached your free limit ($cap). Unlock Pro for unlimited events.'
        : 'Only ${cap - current} left on the free plan. Upgrade for unlimited events.';

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
          TextButton(onPressed: onUpgrade, child: const Text('Upgrade')),
        ],
      ),
    );
  }
}
