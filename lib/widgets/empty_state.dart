import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String emoji;      // "✨" or "🔔"
  final String title;      // JP or EN line
  final String? subtitle;  // optional secondary line

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(title, style: t.headlineMedium, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: t.bodyLarge?.copyWith(color: Colors.grey), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
