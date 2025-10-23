// lib/core/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';


import 'navigation/routes.dart';
// You can keep your themes.dart import if you still use parts of it,
// but the MaterialApp will now take themes from providers:
import '../features/settings/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final lightTheme = ref.watch(themeDataLightProvider);
    final darkTheme  = ref.watch(themeDataDarkProvider);

    return MaterialApp(
      title: 'Countdown App',
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routes: Routes.builders(),
      debugShowCheckedModeBanner: false,
    );
  }
}
