// lib/features/settings/presentation/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/routes.dart';
import '../theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final controller = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // --- Theme radio buttons ---
          RadioListTile<ThemeMode>(
            title: const Text('System default'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setTheme(mode);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setTheme(mode);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setTheme(mode);
            },
          ),

          const Divider(height: 32),

          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English / 日本語'),
            trailing: const Icon(Icons.language),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language toggle coming soon!')),
              );
            },
          ),

          const Divider(height: 32),

          ListTile(
            title: const Text('Upgrade to Pro'),
            trailing: const Icon(Icons.star_rounded, color: Colors.amber),
            onTap: () => Navigator.of(context).pushNamed(Routes.paywall),
          ),

          const Divider(height: 32),

          const ListTile(
            title: Text('App version'),
            subtitle: Text('1.0.0 (MVP)'),
          ),
        ],
      ),
    );
  }
}
