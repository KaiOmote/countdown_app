// countdown_app/lib/core/navigation/routes.dart
import 'package:flutter/material.dart';

// Countdown
import '../../features/countdown/presentation/countdown_list_screen.dart';
import '../../features/countdown/presentation/add_edit_countdown_screen.dart';
import '../../features/countdown/presentation/countdown_detail_screen.dart';

// Settings / Paywall
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/paywall_screen.dart';

class Routes {
  static const root = '/';
  static const countdownDetail = '/countdown/detail';
  static const countdownAddEdit = '/countdown/add_edit';
  static const settings = '/settings';
  static const paywall = '/settings/paywall';

  static Map<String, WidgetBuilder> builders() => {
        // List
        root: (_) => const CountdownListScreen(),

        // Detail (expects a String eventId in arguments)
        countdownDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String) {
            return CountdownDetailScreen(eventId: args);
          }
          return const _RouteErrorScreen(message: 'Missing eventId for detail route');
        },

        // Add/Edit (optional String eventId in arguments; screen reads it)
        countdownAddEdit: (_) => const AddEditCountdownScreen(),

        // Settings & Paywall
        settings: (_) => const SettingsScreen(),
        paywall: (_) => const PaywallScreen(),
      };
}

/// Simple inline error screen for bad route arguments (dev-only).
class _RouteErrorScreen extends StatelessWidget {
  final String message;
  const _RouteErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Error')),
      body: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}
