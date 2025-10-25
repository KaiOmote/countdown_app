import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/routes.dart';
import '../theme_provider.dart';
import '../iap_service.dart';
import 'package:countdown_app/l10n/app_localizations.dart';
import '../language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;

    final themeMode = ref.watch(themeProvider);
    final controller = ref.read(themeProvider.notifier);

    final isProAsync = ref.watch(isProProvider);
    final Widget proTile = isProAsync.when(
      loading: () => ListTile(
        title: Text(s.proChecking),
        trailing: const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => ListTile(
        title: Text(s.upgradePro),
        trailing: const Icon(Icons.star_rounded, color: Colors.amber),
        onTap: () => Navigator.of(context).pushNamed(Routes.paywall),
        subtitle: Text(s.proStatusUnavailable),
      ),
      data: (isPro) => isPro
          ? ListTile(
              title: Text(s.proThanks),
              subtitle: Text(s.proThanksSubtitle),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            )
          : ListTile(
              title: Text(s.upgradePro),
              trailing: const Icon(Icons.star_rounded, color: Colors.amber),
              onTap: () => Navigator.of(context).pushNamed(Routes.paywall),
            ),
    );

    // Language state
    final locale = ref.watch(localeProvider);
    final langCtrl = ref.read(localeProvider.notifier);

    String currentLanguageLabel() {
      if (locale == null) return s.languageSystem;
      if (locale.languageCode == 'ja') return s.languageJapanese;
      return s.languageEnglish;
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(s.theme, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          RadioListTile<ThemeMode>(
            title: Text(s.themeSystem),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setTheme(mode);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(s.themeLight),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setTheme(mode);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(s.themeDark),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) controller.setTheme(mode);
            },
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(s.themeColor, style: Theme.of(context).textTheme.titleMedium),
          ),
          // (your existing color grid kept as-is)
          Consumer(
            builder: (context, ref, _) {
              final selected = ref.watch(seedColorProvider);
              final controller = ref.read(seedColorProvider.notifier);
              final presets = <Color>[
                const Color(0xFFE91E63),
                const Color(0xFF9C27B0),
                const Color(0xFF3F51B5),
                const Color(0xFF03A9F4),
                const Color(0xFF00BCD4),
                const Color(0xFF4CAF50),
                const Color(0xFFFFC107),
                const Color(0xFFFF5722),
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

          // Language tile -> sheet
          ListTile(
            title: Text(s.language),
            subtitle: Text(currentLanguageLabel()),
            trailing: const Icon(Icons.language),
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(title: Text(s.language)),
                    const Divider(height: 0),
                    RadioListTile<Locale?>(
                      value: null,
                      groupValue: locale,
                      onChanged: (_) {
                        langCtrl.setSystem();
                        Navigator.pop(ctx);
                      },
                      title: Text(s.languageSystem),
                    ),
                    const Divider(height: 0),
                    RadioListTile<Locale?>(
                      value: const Locale('en'),
                      groupValue: locale,
                      onChanged: (_) {
                        langCtrl.setEnglish();
                        Navigator.pop(ctx);
                      },
                      title: Text(s.languageEnglish),
                    ),
                    const Divider(height: 0),
                    RadioListTile<Locale?>(
                      value: const Locale('ja'),
                      groupValue: locale,
                      onChanged: (_) {
                        langCtrl.setJapanese();
                        Navigator.pop(ctx);
                      },
                      title: Text(s.languageJapanese),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 32),

          // Purchase status / CTA
          proTile,
          const Divider(height: 32),

          ListTile(
            title: Text(s.appVersion),
            subtitle: Text(s.mvp),
            trailing: TextButton(
              onPressed: IAPService.restore,
              child: Text(s.restorePurchases),
            ),
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
