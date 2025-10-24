// lib/core/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_app/l10n/app_localizations.dart';

import 'navigation/routes.dart';
import '../features/settings/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode  = ref.watch(themeProvider);
    final lightTheme = ref.watch(themeDataLightProvider);
    final darkTheme  = ref.watch(themeDataDarkProvider);

    return MaterialApp(
      title: 'Countdown',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routes: Routes.builders(),
      debugShowCheckedModeBanner: false,

      // l10n
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en'), Locale('ja')],
    );
  }
}
