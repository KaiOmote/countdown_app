// countdown_app/lib/widgets/countdown_card.dart
import 'package:flutter/material.dart';
import '../core/theme/typography.dart'; // AppText

class CountdownCard extends StatelessWidget {
  final String ddayText;   // e.g., "D-12" or "あと12日"
  final String title;      // e.g., "Birthday Party"
  final String dateLabel;  // e.g., "Oct 26, 2024"
  final String? emoji;     // e.g., "🎉"
  final String? note;      // optional small note
  final VoidCallback? onTap;
  final Widget? trailing;  // optional menu

  const CountdownCard({
    super.key,
    required this.ddayText,
    required this.title,
    required this.dateLabel,
    this.emoji,
    this.note,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primaryContainer, cs.secondaryContainer],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ddayText,
                      style: AppText.h1,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (emoji != null)
                    Text(emoji!, style: const TextStyle(fontSize: 20)),
                  if (emoji != null) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: AppText.headline,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dateLabel,
                style: AppText.bodyLarge.copyWith(color: Colors.black54),
              ),
              if (note != null && note!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(note!, style: AppText.bodyLarge),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
