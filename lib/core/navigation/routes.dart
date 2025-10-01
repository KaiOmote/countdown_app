import 'package:flutter/material.dart';

import '../../features/countdown/presentation/countdown_list_screen.dart';
import '../../features/countdown/presentation/add_edit_countdown_screen.dart';
import '../../features/countdown/presentation/countdown_detail_screen.dart';
import '../../features/settings/presentation/paywall_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

class Routes {
  static const root = '/';
  static const countdownDetail = '/countdown/detail';
  static const countdownAddEdit = '/countdown/add_edit';
  static const settings = '/settings';
  static const paywall = '/settings/paywall';

  static Map<String, WidgetBuilder> builders() => {
        // Countdown List (root)
        root: (_) => const CountdownListScreen(),

        // Countdown Detail (requires eventId)
        countdownDetail: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is String) {
            return CountdownDetailScreen(eventId: args);
          }
          return const _PlaceholderScreen(title: 'Countdown Detail (invalid args)');
        },

        // Add/Edit Countdown (optional eventId)
        countdownAddEdit: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is String) {
            return AddEditCountdownScreen(eventId: args); // editing
          }
          return const AddEditCountdownScreen(); // new event
        },

        // Settings
        settings: (_) => const SettingsScreen(),

        // Paywall
        paywall: (_) => const PaywallScreen(),
      };
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
