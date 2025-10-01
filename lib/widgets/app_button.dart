// countdown_app/lib/widgets/app_button.dart
import 'package:flutter/material.dart';
import '../core/theme/typography.dart'; // AppText

enum AppButtonStyle { filled, tonal, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? leading;
  final bool expanded; // true -> full width
  final EdgeInsetsGeometry padding;
  final String? semanticsLabel;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = AppButtonStyle.filled,
    this.leading,
    this.expanded = true,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    this.semanticsLabel,
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
        Flexible(
          child: Text(
            label,
            style: AppText.button,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    Widget button;
    switch (style) {
      case AppButtonStyle.filled:
        button = FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );
        break;

      case AppButtonStyle.tonal:
        button = FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );
        break;

      case AppButtonStyle.outline:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );
        break;
    }

    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      child: expanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
