import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_app/l10n/app_localizations.dart';


import '../../../core/navigation/routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/gaps.dart';
import '../../../widgets/app_button.dart';
import '../../countdown/providers.dart';
import '../../notifications/notification_service.dart';

class CountdownDetailScreen extends ConsumerWidget {
  final String eventId;
  const CountdownDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(countdownRepositoryProvider);
    final events = repo.listAll();
    final matches = events.where((e) => e.id == eventId).toList();
    //s var for localization
    final s = AppLocalizations.of(context)!;

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(s.countdownDetail)),
        body: Center(child: Text(s.eventNotFound)),
      );
    }
    final event = matches.first;

    final locale = Localizations.localeOf(context).toLanguageTag();
    final ddayText = formatDDayLabelL10n(event.dateUtc, DateTime.now(), context);
    final dateLabel = formatDateLocalized(event.dateUtc, locale);

    return Scaffold(
      appBar: AppBar(title: Text(s.countdownDetail)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Text(
              ddayText,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          gap16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (event.emoji != null)
                Text(event.emoji!, style: const TextStyle(fontSize: 24)),
              if (event.emoji != null) const SizedBox(width: 8),
              Text(
                event.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              dateLabel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          gap24,
          if (event.reminderOffsets.isNotEmpty) ...[
            Text('Reminders', style: Theme.of(context).textTheme.labelLarge),
            gap8,
            Wrap(
              spacing: 8,
              children: event.reminderOffsets
                  .map((days) => Chip(label: Text(_labelForOffset(days))))
                  .toList(),
            ),
            gap24,
          ],
          if (event.notes != null && event.notes!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.notes!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            gap24,
          ],
          AppButton(
            label: s.share,
            leading: Icons.share_outlined,
            style: AppButtonStyle.filled,
            onPressed: () {
              final localeTag = Localizations.localeOf(context).toLanguageTag();
              final formattedDate = formatDateLocalized(event.dateUtc, localeTag);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.shareTitleDate(event.title, formattedDate))),
              );
            },
          ),
          gap16,
          AppButton(
            label: s.edit,
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
              if (context.mounted) Navigator.pop(context);
            },
          ),
          gap16,
          AppButton(
            label: s.delete,
            leading: Icons.delete_outline,
            style: AppButtonStyle.outline,
            onPressed: () async {
              final confirmed = await _confirmDelete(context);
              if (!confirmed) return;

              await NotificationService.instance.rescheduleForEvent(
                event.copyWith(reminderOffsets: const []),
              );
              await repo.remove(event.id);
              ref.invalidate(eventsListProvider);
              ref.invalidate(nearestUpcomingProvider);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          gap24,
          if (!bool.fromEnvironment('dart.vm.product')) ...[
            const Divider(),
            const Text(
              'Debug Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            gap12,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(
                  label: 'Show now',
                  expanded: false,
                  onPressed: () async {
                    await NotificationService.instance.showImmediateTest(
                      event.id,
                      event.title,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Immediate notification shown'),
                        ),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'In 30 sec',
                  expanded: false,
                  onPressed: () async {
                    await NotificationService.instance.showTestNotification(
                      event.id,
                      event.title,
                      event.dateUtc,
                      const Duration(seconds: 30),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scheduled in 30 sec')),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'In 1 min',
                  expanded: false,
                  onPressed: () async {
                    await NotificationService.instance.showTestNotification(
                      event.id,
                      event.title,
                      event.dateUtc,
                      const Duration(minutes: 1),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scheduled in 1 min')),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'In 2 min',
                  expanded: false,
                  onPressed: () async {
                    await NotificationService.instance.showTestNotification(
                      event.id,
                      event.title,
                      event.dateUtc,
                      const Duration(minutes: 2),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scheduled in 2 min')),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'In 3 min',
                  expanded: false,
                  onPressed: () async {
                    await NotificationService.instance.showTestNotification(
                      event.id,
                      event.title,
                      event.dateUtc,
                      const Duration(minutes: 3),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scheduled in 3 min')),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'In 5 min',
                  expanded: false,
                  onPressed: () async {
                    await NotificationService.instance.showTestNotification(
                      event.id,
                      event.title,
                      event.dateUtc,
                      const Duration(minutes: 5),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scheduled in 5 min')),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'Cancel debug',
                  expanded: false,
                  style: AppButtonStyle.outline,
                  onPressed: () async {
                    await NotificationService.instance.cancelDebugForEvent(
                      event.id,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cancelled debug notifications'),
                        ),
                      );
                    }
                  },
                ),
                AppButton(
                  label: 'Show status',
                  expanded: false,
                  style: AppButtonStyle.outline,
                  onPressed: () async {
                    final status = await NotificationService.instance
                        .debugStatus();
                    if (!context.mounted) return;
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(s.notificationStatus),
                        content: SingleChildScrollView(child: Text(status)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(s.ok),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _labelForOffset(int days) {
    if (days == 1) return '1 day before';
    if (days == 3) return '3 days before';
    if (days == 7) return '1 week before';
    if (days == 30) return '1 month before';
    return '$days days before';
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        // Get localizations from the *builder* context
        final s = AppLocalizations.of(dialogCtx)!;
        return AlertDialog(
          title: Text(s.deleteCountdownQ),      // no const with s
          content: Text(s.cannotBeUndone),      // no const with s
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(s.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              child: Text(s.delete),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

}
