// lib/core/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/routes.dart';
import 'theme/themes.dart';
import '../features/settings/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Countdown App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routes: Routes.builders(), // ✅ <-- call the method, not a variable
      debugShowCheckedModeBanner: false,
    );
  }
}
