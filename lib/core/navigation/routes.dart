// countdown_app/lib/core/navigation/routes.dart
import 'package:flutter/material.dart';

class Routes {
  static const root = '/';
  static const countdownDetail = '/countdown/detail';
  static const countdownAddEdit = '/countdown/add_edit';
  static const settings = '/settings';
  static const paywall = '/settings/paywall';

  static Map<String, WidgetBuilder> builders() => {
    root: (_) => const _PlaceholderScreen(title: 'Countdown List'),
    countdownDetail: (_) => const _PlaceholderScreen(title: 'Countdown Detail'),
    countdownAddEdit: (_) => const _PlaceholderScreen(title: 'Add/Edit Countdown'),
    settings: (_) => const _PlaceholderScreen(title: 'Settings'),
    paywall: (_) => const _PlaceholderScreen(title: 'Paywall'),
  };
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
