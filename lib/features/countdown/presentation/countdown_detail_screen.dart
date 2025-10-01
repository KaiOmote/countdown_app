import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/gaps.dart';
import '../../../widgets/app_button.dart';
import '../../countdown/providers.dart';
import '../../../core/navigation/routes.dart';

class CountdownDetailScreen extends ConsumerWidget {
  final String eventId;
  const CountdownDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(countdownRepositoryProvider);
    final event = repo.listAll().where((e) => e.id == eventId).firstOrNull;

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Countdown Detail')),
        body: const Center(child: Text('Event not found')),
      );
    }

    final locale = Localizations.localeOf(context).toLanguageTag();
    final ddayText = formatDDayLabel(event.dateUtc, DateTime.now(), locale);
    final dateLabel = formatDateLocalized(event.dateUtc, locale);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Big D-Day
          Center(
            child: Text(
              ddayText,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          gap16,
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (event.emoji != null) Text(event.emoji!, style: const TextStyle(fontSize: 24)),
              if (event.emoji != null) const SizedBox(width: 8),
              Text(
                event.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(dateLabel, style: Theme.of(context).textTheme.bodyLarge),
          ),
          gap24,
          // Notes (if any)
          if (event.notes != null && event.notes!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(event.notes!, style: Theme.of(context).textTheme.bodyLarge),
            ),
            gap24,
          ],
          // Action buttons
          AppButton(
            label: 'Share',
            leading: Icons.share_outlined,
            style: AppButtonStyle.filled,
            onPressed: () {
              // T8: real share. MVP: snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Share: ${event.title} • $dateLabel')),
              );
            },
          ),
          gap16,
          AppButton(
            label: 'Edit',
            leading: Icons.edit_outlined,
            style: AppButtonStyle.tonal,
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                Routes.countdownAddEdit,
                arguments: event.id,
              );
              ref.invalidate(eventsListProvider);
              ref.invalidate(nearestUpcomingProvider);
              Navigator.pop(context); // close detail after edit
            },
          ),
          gap16,
          AppButton(
            label: 'Delete',
            leading: Icons.delete_outline,
            style: AppButtonStyle.outline,
            onPressed: () async {
              final ok = await _confirmDelete(context);
              if (ok) {
                await repo.remove(event.id);
                ref.invalidate(eventsListProvider);
                ref.invalidate(nearestUpcomingProvider);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete countdown?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
