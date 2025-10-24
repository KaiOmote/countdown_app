// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Countdown';

  @override
  String get settings => 'Settings';

  @override
  String get addCountdown => 'Add countdown';

  @override
  String get editCountdown => 'Edit countdown';

  @override
  String get upgradePro => 'Upgrade to Pro';

  @override
  String get themeColor => 'Theme color';

  @override
  String get language => 'Language';

  @override
  String get enableReminders => 'Enable reminders';

  @override
  String get dueToday => 'Today';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# days left',
      one: '# day left',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# days ago',
      one: '# day ago',
    );
    return '$_temp0';
  }
}
