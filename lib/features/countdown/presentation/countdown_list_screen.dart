import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/gaps.dart';
import '../../../widgets/countdown_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/app_button.dart';
import '../../countdown/providers.dart';
import '../../countdown/data/countdown_event.dart';
import '../../../core/navigation/routes.dart';

import '../../notifications/notification_service.dart';


class CountdownListScreen extends ConsumerWidget {
  const CountdownListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsListProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdowns'),
        actions: [
          if (isIOS)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.pushNamed(context, Routes.countdownAddEdit);
                ref.invalidate(eventsListProvider);
                ref.invalidate(nearestUpcomingProvider);
              },
              tooltip: 'New Countdown',
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: events.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    emoji: '✨',
                    title: 'まだカウントダウンがありません！',
                    subtitle: '最初のイベントを追加しましょう🎉',
                  ),
                  gap16,
                  // Inline primary CTA for discoverability
                  AppButton(
                    label: 'New Countdown',
                    leading: Icons.add,
                    onPressed: () async {
                      await Navigator.pushNamed(context, Routes.countdownAddEdit);
                      ref.invalidate(eventsListProvider);
                      ref.invalidate(nearestUpcomingProvider);
                    },
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88), // leave space for FAB/ad
              itemCount: events.length,
              separatorBuilder: (_, __) => gap16,
              itemBuilder: (context, index) {
                final e = events[index];
                return CountdownCard(
                  ddayText: formatDDayLabel(e.dateUtc, DateTime.now(), locale),
                  title: e.title,
                  dateLabel: formatDateLocalized(e.dateUtc, locale),
                  emoji: e.emoji,
                  note: e.notes,
                  onTap: () => Navigator.pushNamed(context, Routes.countdownDetail, arguments: e.id),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _handleMenu(context, ref, value, e),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                      PopupMenuItem(value: 'share', child: Text('Share')),
                    ],
                  ),
                );
              },
            ),
      // FAB only on Android-like platforms
      floatingActionButton: isIOS
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, Routes.countdownAddEdit);
                ref.invalidate(eventsListProvider);
                ref.invalidate(nearestUpcomingProvider);
              },
              tooltip: 'New Countdown',
              child: const Icon(Icons.add),
            ),
    );
  }

  void _handleMenu(BuildContext context, WidgetRef ref, String value, CountdownEvent e) async {
    switch (value) {
      case 'edit':
        await Navigator.pushNamed(context, Routes.countdownAddEdit, arguments: e.id);
        ref.invalidate(eventsListProvider);
        ref.invalidate(nearestUpcomingProvider);
        break;
      case 'delete':
        final ok = await _confirmDelete(context);
        if (ok) {
          // Cancel any scheduled reminders for this event
          await NotificationService.instance
              .rescheduleForEvent(e.copyWith(reminderOffsets: const []));
          await ref.read(countdownRepositoryProvider).remove(e.id);
          ref.invalidate(eventsListProvider);
          ref.invalidate(nearestUpcomingProvider);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
        }
        break;
      case 'share':
        // T8 will implement real share. For now, simple placeholder.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share: ${e.title} • ${e.dateUtc.toIso8601String()}')),
        );
        break;
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete countdown?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    return result ?? false;
  }
}
