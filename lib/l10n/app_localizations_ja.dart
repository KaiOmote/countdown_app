// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'カウントダウン';

  @override
  String get settings => '設定';

  @override
  String get addCountdown => 'カウントダウンを追加';

  @override
  String get editCountdown => 'カウントダウンを編集';

  @override
  String get upgradePro => 'Pro にアップグレード';

  @override
  String get themeColor => 'テーマカラー';

  @override
  String get language => '言語';

  @override
  String get enableReminders => 'リマインダーを有効にする';

  @override
  String get dueToday => '今日';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと # 日',
      one: 'あと # 日',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# 日前',
      one: '# 日前',
    );
    return '$_temp0';
  }
}
