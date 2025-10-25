// countdown_app/lib/core/utils/formatters.dart
import 'package:intl/intl.dart';
import 'package:countdown_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

String formatDateLocalized(DateTime utc, String locale) {
  // NOTE: will refine in T12, for now basic yMMMd
  final local = utc.toLocal();
  return DateFormat.yMMMd(locale).format(local);
}

String formatDDayLabel(DateTime targetUtc, DateTime nowLocal, String locale) {
  final targetLocal = targetUtc.toLocal();
  final now = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
  final target = DateTime(targetLocal.year, targetLocal.month, targetLocal.day);
  final diff = target.difference(now).inDays;
  if (diff > 0) return '$diff days';
  if (diff == 0) return 'Today';
  return '${diff.abs()} days ago';
}

String formatDDayLabelL10n(DateTime targetUtc, DateTime nowUtcOrLocal, BuildContext context) {
  final s = AppLocalizations.of(context)!;
  final now = nowUtcOrLocal.toUtc();
  final target = DateTime.utc(targetUtc.year, targetUtc.month, targetUtc.day);
  final today = DateTime.utc(now.year, now.month, now.day);
  final diff = target.difference(today).inDays;

  if (diff == 0) return s.dueToday;
  if (diff > 0) return s.daysLeft(diff);
  return s.daysAgo(-diff);
}
