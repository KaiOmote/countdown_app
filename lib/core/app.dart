// lib/core/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/routes.dart';
import '../features/settings/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode  = ref.watch(themeProvider);              // <- from theme_provider.dart
    final lightTheme = ref.watch(themeDataLightProvider);     // <- from theme_provider.dart
    final darkTheme  = ref.watch(themeDataDarkProvider);      // <- from theme_provider.dart

    return MaterialApp(
      title: 'Countdown',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routes: Routes.builders(),
      debugShowCheckedModeBanner: false,
      // Localization is intentionally disabled for now to avoid the S/AppLocalizations mismatch.
      // Add it back once we pick a single i18n system.
    );
  }
}
