import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_app/l10n/app_localizations.dart';


import '../../../core/utils/formatters.dart';
import '../../../core/utils/gaps.dart';
import '../../../widgets/countdown_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/app_button.dart';
import '../../countdown/providers.dart';
import '../../countdown/data/countdown_event.dart';
import '../../../core/navigation/routes.dart';
import '../../settings/iap_service.dart';
import '../../../core/utils/constants.dart';
import 'widgets/free_cap_banner.dart';

import '../../notifications/notification_service.dart';


class CountdownListScreen extends ConsumerWidget {
  const CountdownListScreen({super.key});

@override
Widget build(BuildContext context, WidgetRef ref) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  final isProAsync = ref.watch(isProProvider);
  // s var for localization
  final s = AppLocalizations.of(context)!;


  // Plain List<CountdownEvent>
  final events = ref.watch(eventsListProvider);

  const cap = kFreeEventCap;

  final maybeBanner = isProAsync.when(
    loading: () => null,
    error: (_, __) => null,
    data: (isPro) {
      if (isPro) return null;
      if (events.length >= cap - 1) {
        return FreeCapBanner(
          current: events.length,
          cap: cap,
          onUpgrade: () => Navigator.of(context).pushNamed(Routes.paywall),
        );
      }
      return null;
    },
  );

  return Scaffold(
    appBar: AppBar(
      title: const Text(s.appTitle),
      actions: [
        if (isIOS)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, Routes.countdownAddEdit);
              if (!context.mounted) return;                       // <-- guard
              ref.invalidate(eventsListProvider);
              ref.invalidate(nearestUpcomingProvider);
            },
            tooltip: s.newCountdownapp,
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
                AppButton(
                  label: s.newCountdown,
                  leading: Icons.add,
                  onPressed: () async {
                    await Navigator.pushNamed(context, Routes.countdownAddEdit);
                    if (!context.mounted) return;                 // <-- guard
                    ref.invalidate(eventsListProvider);
                    ref.invalidate(nearestUpcomingProvider);
                  },
                ),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: events.length + (maybeBanner != null ? 1 : 0),
            separatorBuilder: (_, __) => gap16,
            itemBuilder: (context, index) {
              if (maybeBanner != null && index == 0) return maybeBanner;

              final eventIndex = maybeBanner != null ? index - 1 : index;
              final e = events[eventIndex];

              return CountdownCard(
                ddayText: formatDDayLabel(e.dateUtc, DateTime.now(), locale),
                title: e.title,
                dateLabel: formatDateLocalized(e.dateUtc, locale),
                emoji: e.emoji,
                note: e.notes,
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.countdownDetail,
                  arguments: e.id,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) => _handleMenu(context, ref, value, e),
                  itemBuilder: (ctx) {
                    final s = AppLocalizations.of(ctx)!;
                    return [
                      PopupMenuItem(value: 'edit', child: Text(s.editCountdown)),
                      PopupMenuItem(value: 'delete', child: Text(s.delete)),
                      PopupMenuItem(value: 'share', child: const Text(s.share)), 
                    ];
                  },
                ),
              );
            },
          ),
    floatingActionButton: isIOS
        ? null
        : FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, Routes.countdownAddEdit);
              if (!context.mounted) return;                       // <-- guard
              ref.invalidate(eventsListProvider);
              ref.invalidate(nearestUpcomingProvider);
            },
            tooltip: 'New Countdown',
            child: const Icon(Icons.add),
          ),
  );
}

  void _handleMenu(BuildContext context, WidgetRef ref, String value, CountdownEvent e) async {
    final s = AppLocalizations.of(context)!; // <-- bring s into scope here

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

          // 🔴 remove `const` so we can use s
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.deleted)),
          );
        }
        break;

      case 'share':
        // Placeholder
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.shareTitleIso(e.title, e.dateUtc.toIso8601String()))),
        );
        break;
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.deleteCountdownQ)
        content: Text(s.cannotBeUndone),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text(s.delete)),
        ],
      ),
    );
    return result ?? false;
  }
}
