import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/gaps.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/section_tile.dart';
import '../../../core/navigation/routes.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')), // "Settings"
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme tile
          SectionTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: 'テーマ',
            trailing: const Text('パステル'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme picker not yet implemented')),
              );
            },
          ),
          gap12,
          // Dark mode switch
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('ダークモード'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (val) {
              // TODO T10: wire to themeProvider
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dark mode toggle not yet wired')),
              );
            },
          ),
          gap24,
          // Pro unlock card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB3C7), Color(0xFFB8F2E6), Color(0xFFCFB7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Proで全機能解放',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                gap8,
                const Text(
                  '広告非表示、無制限のウィジェット、特別なテーマを手に入れよう！',
                ),
                gap16,
                AppButton(
                  label: '詳細を見る',
                  style: AppButtonStyle.filled,
                  expanded: false,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.paywall);
                  },
                ),
              ],
            ),
          ),
          gap24,
          // Other settings
          SectionTile(
            leading: const Icon(Icons.notifications_outlined),
            title: '通知設定',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings not yet implemented')),
              );
            },
          ),
          gap12,
          SectionTile(
            leading: const Icon(Icons.help_outline),
            title: 'ヘルプとフィードバック',
            onTap: () {
              // TODO: implement help/feedback
            },
          ),
          gap12,
          SectionTile(
            leading: const Icon(Icons.info_outline),
            title: 'アプリについて',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Countdown',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Your Name',
              );
            },
          ),
        ],
      ),
    );
  }
}
