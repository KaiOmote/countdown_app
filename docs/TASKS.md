# T3 — Shared UI Components (Widgets Only)

## Context
Create a small **UI kit** (presentational widgets) that all screens will reuse.  
This prevents Gemini from improvising layouts and keeps visual consistency.  
**No business logic, no providers, no navigation here.** Static baseline only.

## Files to Create
- `lib/widgets/app_button.dart`
- `lib/widgets/app_text_field.dart`
- `lib/widgets/empty_state.dart`
- `lib/widgets/section_tile.dart`
- `lib/widgets/countdown_card.dart`
- *(dev-only)* `lib/dev/ui_playground.dart` – a temporary screen to preview all widgets

---

## T3.A — `app_button.dart`
**Goal:** One button API with 3 styles (filled / tonal / outline), consistent size, rounded corners.

```dart
// lib/widgets/app_button.dart
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
        final s = FilledButton.tonalStyleFrom(
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
```

**Manual tests**
- Render filled/tonal/outline; with & without leading icon; expanded & non-expanded.
- Heights and corner radii match across variants.

---

## T3.B — `app_text_field.dart`
**Goal:** Consistent text input styling (labels above, rounded, filled background).

```dart
// lib/widgets/app_text_field.dart
import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: trailing,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
```

**Manual tests**
- Single-line vs multi-line.
- Read-only variant (for date field).
- Long text wraps in notes; label/hint behave correctly.

---

## T3.C — `empty_state.dart`
**Goal:** Reusable centered empty state for the list screen.

```dart
// lib/widgets/empty_state.dart
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
```

**Manual tests**
- Different emoji.
- Very long subtitle wrapping.

---

## T3.D — `section_tile.dart`
**Goal:** Settings row with leading icon/emoji, label, optional subtitle, and trailing (switch/chevron).

```dart
// lib/widgets/section_tile.dart
import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SectionTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: t.bodySmall),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
```

**Manual tests**
- With trailing switch, with chevron, with none.
- Ink ripple respects rounded corners.

---

## T3.E — `countdown_card.dart`
**Goal:** A large card for the detail/list style: big D-day text, title+emoji, date, optional note.

```dart
// lib/widgets/countdown_card.dart
import 'package:flutter/material.dart';

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
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Subtle pastel gradient; real colors come from theme.
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
                  Expanded(child: Text(ddayText, style: t.displayLarge)),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (emoji != null) Text(emoji!, style: const TextStyle(fontSize: 20)),
                  if (emoji != null) const SizedBox(width: 8),
                  Expanded(child: Text(title, style: t.headlineMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 4),
              Text(dateLabel, style: t.bodyLarge?.copyWith(color: Colors.black54)),
              if (note != null && note!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(note!, style: t.bodyLarge),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

**Manual tests**
- With & without `emoji`.
- With & without `note`.
- Long titles truncate nicely (2 lines max).

---

## *(Optional)* T3.F — UI Playground (dev only)
**Goal:** One temporary screen that shows all widgets in different states for quick visual checks.

```dart
// lib/dev/ui_playground.dart  (DEV ONLY — do not ship)
// Temporarily set as home/route to preview widgets quickly.
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_tile.dart';
import '../widgets/countdown_card.dart';

class UiPlayground extends StatefulWidget {
  const UiPlayground({super.key});
  @override
  State<UiPlayground> createState() => _UiPlaygroundState();
}

class _UiPlaygroundState extends State<UiPlayground> {
  final title = TextEditingController(text: 'Birthday Party');
  final notes = TextEditingController(text: 'Don\'t forget to buy a cake!');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI Playground')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const EmptyState(
            emoji: '✨',
            title: 'まだカウントダウンがありません！',
            subtitle: '最初のイベントを追加しましょう🎉',
          ),
          const SizedBox(height: 24),
          const CountdownCard(
            ddayText: 'D-12',
            title: 'Birthday Party',
            dateLabel: 'Oct 26, 2024',
            emoji: '🎉',
            note: 'Don\'t forget to buy a cake!',
          ),
          const SizedBox(height: 24),
          AppTextField(controller: title, label: 'Title', hint: 'e.g. Birthday Party'),
          const SizedBox(height: 16),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          const SizedBox(height: 16),
          const AppButton(label: 'Filled Button'),
          const SizedBox(height: 8),
          const AppButton(label: 'Tonal Button', style: AppButtonStyle.tonal),
          const SizedBox(height: 8),
          const AppButton(label: 'Outline Button', style: AppButtonStyle.outline),
          const SizedBox(height: 24),
          const SectionTile(
            leading: Text('🎨', style: TextStyle(fontSize: 20)),
            title: 'テーマ',
            subtitle: 'パステル',
            trailing: Icon(Icons.chevron_right),
          ),
          const SectionTile(
            leading: Text('🌙', style: TextStyle(fontSize: 20)),
            title: 'ダークモード',
            trailing: Switch(value: true, onChanged: null), // demo
          ),
        ],
      ),
    );
  }
}
```

*(Temporarily point your `MaterialApp` home/route to `UiPlayground` to verify UI, then remove.)*

---

## Commands
- `flutter pub get`
- `flutter analyze`
- `flutter run`  *(load the playground or render samples somewhere temporary)*

---

## Acceptance Criteria
- All five widgets compile with **0 analyzer errors**.
- Visuals match the static mock style (rounded corners, pastel gradient where used).
- Widgets are **presentational only** (no repository, no Riverpod, no navigation).
- Components behave consistently: same padding, radius, typography across usages.

---

## Troubleshooting
- **Ripple leaks past rounded corners** → ensure `InkWell` wraps a parent `Ink` with the same `borderRadius`.
- **Text truncation** → add `maxLines` + `TextOverflow.ellipsis` on long titles.
- **Gradient looks harsh** → soften with `primaryContainer/secondaryContainer` or reduce saturation in theme.
