import 'package:flutter/material.dart';

enum AppButtonStyle { filled, tonal, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? leading;
  final bool expanded; // true -> full width
  final EdgeInsetsGeometry padding;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = AppButtonStyle.filled,
    this.leading,
    this.expanded = true,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          Icon(leading, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    switch (style) {
      case AppButtonStyle.filled:
        final s = FilledButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        );
        final w = FilledButton(onPressed: onPressed, style: s, child: child);
        return expanded ? SizedBox(width: double.infinity, child: w) : w;

      case AppButtonStyle.tonal:
        final s = FilledButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        );
        final w = FilledButton.tonal(onPressed: onPressed, style: s, child: child);
        return expanded ? SizedBox(width: double.infinity, child: w) : w;

      case AppButtonStyle.outline:
        final s = OutlinedButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        );
        final w = OutlinedButton(onPressed: onPressed, style: s, child: child);
        return expanded ? SizedBox(width: double.infinity, child: w) : w;
    }
  }
}
