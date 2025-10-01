// countdown_app/lib/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import '../core/theme/typography.dart'; // AppText

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;     // e.g., "Title"
  final String? hint;     // e.g., "e.g. Birthday Party"
  final int maxLines;     // >1 for Notes
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? trailing; // suffixIcon (e.g., date icon)
  final bool readOnly;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.trailing,
    this.readOnly = false,
    this.onTap,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: semanticsLabel ?? label,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        readOnly: readOnly,
        onTap: onTap,
        style: AppText.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: trailing,
          // Borders & filled handled by inputDecorationTheme in ThemeData
        ),
      ),
    );
  }
}
