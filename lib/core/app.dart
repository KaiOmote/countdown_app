// countdown_app/lib/core/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/themes.dart';
import 'navigation/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Countdown',
        theme: lightTheme,
        darkTheme: darkTheme,
        routes: Routes.builders(),
        initialRoute: Routes.root,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
