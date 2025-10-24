// lib/features/settings/presentation/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/routes.dart';
import '../theme_provider.dart';
import '../iap_service.dart';

// NEW: language state (persisted in Hive via settings box)
import '../language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final controller = ref.read(themeProvider.notifier);

    // 👇 Watch Pro entitlement once, then build the tile
    final isProAsync = ref.watch(isProProvider);
    final Widget proTile = isProAsync.when(
      loading: () => const ListTile(
        title: Text('Checking Pro status…'),
        trailing: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => ListTile(
        title: const Text('Upgrade to Pro'),
        trailing: const Icon(Icons.star_rounded, color: Colors.amber),
        onTap: () => Navigator.of(context).pushNamed(Routes.paywall),
        subtitle: const Text('Status unavailable — tap to manage'),
      ),
      data: (isPro) => isPro
          ? const ListTile(
              title: Text('You’re Pro! 🎉'),
              subtitle: Text('Thank you for supporting the app'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            )
          : ListTile(
              title: const Text('Upgrade to Pro'),
              trailing: const Icon(Icons.star_rounded, color: Colors.amber),
              onTap: () => Navigator.of(context).pushNamed(Routes.paywall),
            ),
    );

    // 🔤 Language state (null = System default)
    final locale = ref.watch(localeProvider);
    final langCtrl = ref.read(localeProvider.notifier);

    String currentLanguageLabel() {
      if (locale == null) return 'System default';
      if (locale.languageCode == 'ja') return '日本語';
      return 'English';
    }

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

          // --- Theme Color (seed) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Theme color', style: Theme.of(context).textTheme.titleMedium),
          ),
          Consumer(
            builder: (context, ref, _) {
              final selected = ref.watch(seedColorProvider);
              final controller = ref.read(seedColorProvider.notifier);

              // Quick presets; tweak colors to your brand vibe
              final presets = <Color>[
                const Color(0xFFE91E63), // pink
                const Color(0xFF9C27B0), // purple
                const Color(0xFF3F51B5), // indigo
                const Color(0xFF03A9F4), // light blue
                const Color(0xFF00BCD4), // cyan
                const Color(0xFF4CAF50), // green
                const Color(0xFFFFC107), // amber
                const Color(0xFFFF5722), // deep orange
              ];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final c in presets)
                      _ColorDot(
                        color: c,
                        selected: _isSameColor(selected, c),
                        onTap: () => controller.setSeed(c),
                      ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 32),

          // --- Language (runtime switching with persistence) ---
          ListTile(
            title: const Text('Language'),
            subtitle: Text(currentLanguageLabel()),
            trailing: const Icon(Icons.language),
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) {
                  final scheme = Theme.of(ctx).colorScheme;
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Language', style: Theme.of(ctx).textTheme.titleMedium),
                        ),
                        const Divider(height: 0),
                        RadioListTile<Locale?>(
                          value: null,
                          groupValue: locale,
                          onChanged: (_) {
                            langCtrl.setSystem();
                            Navigator.pop(ctx);
                          },
                          title: const Text('System default'),
                        ),
                        const Divider(height: 0),
                        RadioListTile<Locale?>(
                          value: const Locale('en'),
                          groupValue: locale,
                          onChanged: (_) {
                            langCtrl.setEnglish();
                            Navigator.pop(ctx);
                          },
                          title: const Text('English'),
                        ),
                        const Divider(height: 0),
                        RadioListTile<Locale?>(
                          value: const Locale('ja'),
                          groupValue: locale,
                          onChanged: (_) {
                            langCtrl.setJapanese();
                            Navigator.pop(ctx);
                          },
                          title: const Text('日本語'),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Changes apply immediately and persist across app restarts.',
                            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          const Divider(height: 32),

          // --- Purchase status / CTA ---
          proTile,

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

bool _isSameColor(Color a, Color b) => a.value == b.value;

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = selected
        ? Border.all(width: 3, color: Theme.of(context).colorScheme.primary)
        : Border.all(width: 1, color: Theme.of(context).dividerColor);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border,
          boxShadow: [
            if (selected)
              BoxShadow(
                blurRadius: 8,
                spreadRadius: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
          ],
        ),
      ),
    );
  }
}
