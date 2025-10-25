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
  String get language => '言語';

  @override
  String get languageSystem => '端末の設定に従う';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSystem => '端末の設定に従う';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeColor => 'テーマカラー';

  @override
  String get addCountdown => 'カウントダウンを追加';

  @override
  String get editCountdown => 'カウントダウンを編集';

  @override
  String get selectDate => '日付を選択';

  @override
  String get notes => 'メモ';

  @override
  String get optionalNotes => '任意のメモ';

  @override
  String get createFirst => '最初のカウントダウンを作成しましょう。';

  @override
  String get notFound => '見つかりません';

  @override
  String get upgradePro => 'Pro にアップグレード';

  @override
  String get proThanks => 'Proをお使いです！🎉';

  @override
  String get proThanksSubtitle => 'ご支援ありがとうございます';

  @override
  String get proChecking => 'Proの状態を確認中…';

  @override
  String get proStatusUnavailable => '状態を取得できません — タップして管理';

  @override
  String get restorePurchases => '購入情報を復元';

  @override
  String get appVersion => 'アプリのバージョン';

  @override
  String get mvp => '1.0.0 (MVP)';

  @override
  String get titleLabel => 'タイトル';

  @override
  String get newCountdown => '新しいカウントダウン';

  @override
  String get editCountdownFull => 'カウントダウンを編集';

  @override
  String get saveCountdown => '保存';

  @override
  String get reminders => 'リマインダー';

  @override
  String daysBeforeEvent(Object days) {
    return 'イベントの$days日前';
  }

  @override
  String get customReminder => 'カスタムリマインダー';

  @override
  String get customPlus => '＋ カスタム';

  @override
  String get add => '追加';

  @override
  String get deleted => '削除しました';

  @override
  String get deleteCountdownQ => 'このカウントダウンを削除しますか？';

  @override
  String get cannotBeUndone => '元に戻せません。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get countdownDetail => 'カウントダウン詳細';

  @override
  String get notificationStatus => '通知の状態';

  @override
  String get ok => 'OK';

  @override
  String get share => '共有';

  @override
  String shareTitleDate(Object date, Object title) {
    return '共有: $title - $date';
  }

  @override
  String shareTitleIso(Object dateIso, Object title) {
    return '共有: $title • $dateIso';
  }

  @override
  String scheduledInMinutes(Object minutes) {
    return '$minutes分後に通知';
  }

  @override
  String scheduledInSeconds(Object seconds) {
    return '$seconds秒後に通知';
  }

  @override
  String get dueToday => '今日';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '残り # 日',
      one: '残り # 日',
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
