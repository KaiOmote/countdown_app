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
  String get noCountdownsMsg => 'まだカウントダウンを作成してません！';

  @override
  String get addCountdown => 'カウントダウンを追加';

  @override
  String get editCountdown => 'カウントダウンを編集';

  @override
  String get edit => '編集';

  @override
  String get selectDate => '日付を選択';

  @override
  String get notes => 'メモ';

  @override
  String get optionalNotes => '任意のメモ';

  @override
  String get createFirst => '最初のカウントダウンを作成しましょう🎉';

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
  String get saveChanges => '保存';

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
  String get eventNotFound => 'イベントが見つかりません';

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
      other: '残り$count日',
      one: '残り$count日',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日前',
      one: '$count日前',
    );
    return '$_temp0';
  }

  @override
  String get exampleEventHint => '例: 誕生日パーティー';

  @override
  String get dateLabel => '日付';

  @override
  String get iconLabel => 'アイコン';

  @override
  String get egTen => '例: 10';

  @override
  String get enterTitle => 'タイトルを入力してください';

  @override
  String get chooseDate => '日付を選択してください';

  @override
  String get enterPositiveDays => '1以上の日数を入力してください';

  @override
  String get countdownAdded => 'カウントダウンを追加しました';

  @override
  String get paywallUnlockTitle => 'Pro版をアンロック';

  @override
  String get paywallSubtitle => '無制限のイベント、限定テーマ、広告なしの体験を手に入れましょう。';

  @override
  String get paywallFeatureHeader => '機能';

  @override
  String get paywallFreeColumn => '無料';

  @override
  String get paywallProColumn => 'Pro';

  @override
  String get paywallFeatureEventLimit => 'イベント上限';

  @override
  String get paywallFeatureThemes => 'テーマ';

  @override
  String get paywallFeatureAdFree => '広告なし';

  @override
  String get paywallEventLimitPro => '無制限';

  @override
  String get paywallThemeFree => 'ベーシック';

  @override
  String get paywallThemePro => '限定';

  @override
  String get paywallAdFreeFree => 'いいえ';

  @override
  String get paywallAdFreePro => 'はい';

  @override
  String get paywallAlreadyPro => 'すでにPro版を利用中です';

  @override
  String get paywallProcessing => '処理中...';

  @override
  String get paywallPurchaseSuccess => 'Pro版がアンロックされました！';

  @override
  String get paywallPurchaseCancelled => '購入はキャンセルされました';

  @override
  String paywallPurchaseFailed(String error) {
    return '購入に失敗しました: $error';
  }

  @override
  String paywallOneTimePrice(String price) {
    return '買い切り $price';
  }

  @override
  String get paywallRestoreSuccess => '購入履歴を復元しました';

  @override
  String paywallRestoreFailed(String error) {
    return '復元に失敗しました: $error';
  }

  @override
  String paywallGenericError(String message) {
    return '問題が発生しました。\n$message';
  }

  @override
  String freeCapBannerAtLimit(int cap) {
    return '無料プランの上限（$cap件）に達しました。無制限のイベントのためにPro版をアンロックしましょう。';
  }

  @override
  String freeCapBannerRemaining(int remaining) {
    return '無料プランで残り$remaining件です。無制限にするにはアップグレードしましょう。';
  }

  @override
  String get freeCapBannerUpgrade => 'アップグレード';

  @override
  String get reminderOffsetOneDay => '1日前';

  @override
  String get reminderOffsetThreeDays => '3日前';

  @override
  String get reminderOffsetOneWeek => '1週間前';

  @override
  String get reminderOffsetOneMonth => '1か月前';

  @override
  String reminderOffsetDays(int days) {
    return '$days日前';
  }

  @override
  String get routeErrorTitle => 'ルートエラー';

  @override
  String get routeErrorMissingEvent => '詳細画面に必要な eventId がありません。';

  @override
  String get reminderPresetOneDay => '1日';

  @override
  String get reminderPresetThreeDays => '3日';

  @override
  String get reminderPresetOneWeek => '1週';

  @override
  String get reminderPresetOneMonth => '1か月';

  @override
  String get notificationChannelName => 'カウントダウンのリマインダー';

  @override
  String get notificationChannelDescription => 'イベントのリマインダー通知を送信します。';

  @override
  String notificationTitleUpcoming(String title) {
    return 'まもなく開催: $title';
  }

  @override
  String notificationTitleTest(String title) {
    return 'テスト: $title';
  }

  @override
  String notificationBodyToday(String title) {
    return '今日は$titleの日です';
  }

  @override
  String notificationBodyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと$count日です',
      one: 'あと$count日です',
    );
    return '$_temp0';
  }

  @override
  String get notificationBodyOneWeek => 'あと1週間です';

  @override
  String notificationBodyMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと$countか月です',
      one: 'あと$countか月です',
    );
    return '$_temp0';
  }

  @override
  String get notificationDebugImmediate => '即時通知';

  @override
  String notificationDebugScheduled(String time) {
    return 'テスト通知 - $timeに送信されます';
  }
}
