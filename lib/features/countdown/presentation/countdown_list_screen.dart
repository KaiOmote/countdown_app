// lib/features/countdown/presentation/countdown_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:countdown_app/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

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
import '../../../core/utils/share_utils.dart';
import 'widgets/free_cap_banner.dart';
import '../../notifications/notification_service.dart';

class CountdownListScreen extends ConsumerWidget {
  const CountdownListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final isProAsync = ref.watch(isProProvider);

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
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          if (isIOS)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.pushNamed(context, Routes.countdownAddEdit);
                if (!context.mounted) return; // guard after async
                ref.invalidate(eventsListProvider);
                ref.invalidate(nearestUpcomingProvider);
              },
              tooltip: AppLocalizations.of(context)!.newCountdown,
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
                  EmptyState(
                    emoji: '✨',
                    title: AppLocalizations.of(context)!.noCountdownsMsg,
                    subtitle: AppLocalizations.of(context)!.createFirst,
                  ),
                  gap16,
                  AppButton(
                    label: AppLocalizations.of(context)!.newCountdown,
                    leading: Icons.add,
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        Routes.countdownAddEdit,
                      );
                      if (!context.mounted) return;
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

                final shareKey = GlobalObjectKey('card-${e.id}');
                return RepaintBoundary(
                  key: shareKey,
                  child: CountdownCard(
                    ddayText: formatDDayLabelL10n(
                      e.dateUtc,
                      DateTime.now(),
                      context,
                    ),
                    title: e.title,
                    dateLabel: formatDateLocalized(e.dateUtc, localeTag),
                    emoji: e.emoji,
                    note: e.notes,
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.countdownDetail,
                      arguments: e.id,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) =>
                          _handleMenu(context, ref, value, e, shareKey),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(AppLocalizations.of(ctx)!.editCountdown),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(AppLocalizations.of(ctx)!.delete),
                        ),
                        PopupMenuItem(
                          value: 'share',
                          child: Text(AppLocalizations.of(ctx)!.share),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: isIOS
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, Routes.countdownAddEdit);
                if (!context.mounted) return;
                ref.invalidate(eventsListProvider);
                ref.invalidate(nearestUpcomingProvider);
              },
              tooltip: AppLocalizations.of(context)!.newCountdown,
              child: const Icon(Icons.add),
            ),
    );
  }

  void _handleMenu(
    BuildContext context,
    WidgetRef ref,
    String value,
    CountdownEvent e,
    GlobalKey shareKey,
  ) async {
    switch (value) {
      case 'edit':
        await Navigator.pushNamed(
          context,
          Routes.countdownAddEdit,
          arguments: e.id,
        );
        ref.invalidate(eventsListProvider);
        ref.invalidate(nearestUpcomingProvider);
        break;

      case 'delete':
        final ok = await _confirmDelete(context);
        if (ok) {
          // Cancel any scheduled reminders for this event
          await NotificationService.instance.rescheduleForEvent(
            e.copyWith(reminderOffsets: const []),
          );
          await ref.read(countdownRepositoryProvider).remove(e.id);
          ref.invalidate(eventsListProvider);
          ref.invalidate(nearestUpcomingProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.deleted)),
          );
        }
        break;

      case 'share':
        final s = AppLocalizations.of(context)!;
        await showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: Text(s.shareAs)),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: Text(s.shareAsImage),
                  onTap: () async {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.shareImageGenerating)),
                    );
                    final ok = await ShareUtils.shareBoundaryAsImage(
                      key: shareKey,
                      subject: s.appTitle,
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(s.shareImageFailed)),
                      );
                    }
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.notes_outlined),
                  title: Text(s.shareAsText),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final localeTag = Localizations.localeOf(
                      context,
                    ).toLanguageTag();
                    final formattedDate = formatDateLocalized(
                      e.dateUtc,
                      localeTag,
                    );
                    final ddayText = formatDDayLabelL10n(
                      e.dateUtc,
                      DateTime.now(),
                      context,
                    );
                    final shareText = [
                      '${e.emoji ?? '🎉'} ${e.title}',
                      formattedDate,
                      ddayText,
                    ].join('\n');
                    await Future.delayed(const Duration(milliseconds: 120));
                    await Share.share(shareText, subject: s.appTitle);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
        break;
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(AppLocalizations.of(dialogCtx)!.deleteCountdownQ),
        content: Text(AppLocalizations.of(dialogCtx)!.cannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(AppLocalizations.of(dialogCtx)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(AppLocalizations.of(dialogCtx)!.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
