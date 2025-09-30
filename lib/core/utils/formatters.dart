import 'package:intl/intl.dart';

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
