// lib/features/countdown/presentation/countdown_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_app/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/navigation/routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/gaps.dart';
import '../../../widgets/app_button.dart';
import '../../countdown/providers.dart';
import '../../notifications/notification_service.dart';
import '../../../core/utils/share_utils.dart';

class CountdownDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const CountdownDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<CountdownDetailScreen> createState() =>
      _CountdownDetailScreenState();
}

class _CountdownDetailScreenState
    extends ConsumerState<CountdownDetailScreen> {
  // Persist the capture key across rebuilds
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(countdownRepositoryProvider);
    final events = repo.listAll();
    final matches = events.where((e) => e.id == widget.eventId).toList();

    final s = AppLocalizations.of(context)!;

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(s.countdownDetail)),
        body: Center(child: Text(s.eventNotFound)),
      );
    }
    final event = matches.first;

    final locale = Localizations.localeOf(context).toLanguageTag();
    final ddayText = formatDDayLabelL10n(
      event.dateUtc,
      DateTime.now(),
      context,
    );
    final dateLabel = formatDateLocalized(event.dateUtc, locale);

    return Scaffold(
      appBar: AppBar(title: Text(s.countdownDetail)),
      body: RepaintBoundary(
        key: _boundaryKey,
        child: Material(
          // Ensures a solid background in the captured image
          color: Theme.of(context).colorScheme.surface,
          child: ListView(
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

              // Reminders
              if (event.reminderOffsets.isNotEmpty) ...[
                Text(s.reminders, style: Theme.of(context).textTheme.labelLarge),
                gap8,
                Wrap(
                  spacing: 8,
                  children: event.reminderOffsets
                      .map((days) => Chip(label: Text(_labelForOffset(s, days))))
                      .toList(),
                ),
                gap24,
              ],

              // Notes
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

              // Share
              AppButton(
                label: s.share,
                leading: Icons.share_outlined,
                style: AppButtonStyle.filled,
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(title: Text(s.shareAs)),
                          const Divider(height: 0),

                          // Share as Image
                          ListTile(
                            leading: const Icon(Icons.image_outlined),
                            title: Text(s.shareAsImage),
                            onTap: () async {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(s.shareImageGenerating)),
                              );
                              final ok = await ShareUtils.shareBoundaryAsImage(
                                key: _boundaryKey,
                                subject: s.appTitle,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              if (!ok && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(s.shareImageFailed)),
                                );
                              }
                            },
                          ),
                          const Divider(height: 0),

                          // Share as Text
                          ListTile(
                            leading: const Icon(Icons.notes_outlined),
                            title: Text(s.shareAsText),
                            onTap: () async {
                              Navigator.pop(ctx);

                              final localeTag = Localizations.localeOf(context)
                                  .toLanguageTag();
                              final formattedDate = formatDateLocalized(
                                event.dateUtc,
                                localeTag,
                              );
                              final dday = formatDDayLabelL10n(
                                event.dateUtc,
                                DateTime.now(),
                                context,
                              );
                              final text = [
                                '${event.emoji ?? '🎉'} ${event.title}',
                                formattedDate,
                                dday,
                              ].join('\n');

                              // Let the sheet dismiss cleanly first
                              await Future.delayed(
                                const Duration(milliseconds: 120),
                              );
                              await Share.share(text, subject: s.appTitle);
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
              gap16,

              // Edit
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

              // Delete
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

              // Debug block (unchanged)
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
                            const SnackBar(
                                content: Text('Scheduled in 30 sec')),
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
                            const SnackBar(
                                content: Text('Scheduled in 1 min')),
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
                            const SnackBar(
                                content: Text('Scheduled in 2 min')),
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
                            const SnackBar(
                                content: Text('Scheduled in 3 min')),
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
                            const SnackBar(
                                content: Text('Scheduled in 5 min')),
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
                        final status =
                            await NotificationService.instance.debugStatus();
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
        ),
      ),
    );
  }

  String _labelForOffset(AppLocalizations s, int days) {
    if (days == 1) return s.reminderOffsetOneDay;
    if (days == 3) return s.reminderOffsetThreeDays;
    if (days == 7) return s.reminderOffsetOneWeek;
    if (days == 30) return s.reminderOffsetOneMonth;
    return s.reminderOffsetDays(days);
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) {
        final s = AppLocalizations.of(dialogCtx)!;
        return AlertDialog(
          title: Text(s.deleteCountdownQ),
          content: Text(s.cannotBeUndone),
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
