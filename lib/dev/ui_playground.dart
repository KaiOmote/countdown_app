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
