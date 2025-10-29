// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Countdowns';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => '日本語';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeColor => 'Theme color';

  @override
  String get noCountdownsMsg => 'You have no countdowns yet!';

  @override
  String get addCountdown => 'Add countdown';

  @override
  String get editCountdown => 'Edit countdown';

  @override
  String get edit => 'Edit';

  @override
  String get selectDate => 'Select date';

  @override
  String get notes => 'Notes';

  @override
  String get optionalNotes => 'Optional notes';

  @override
  String get createFirst => 'Create your first countdown to get started🎉';

  @override
  String get notFound => 'Not found';

  @override
  String get upgradePro => 'Upgrade to Pro';

  @override
  String get proThanks => 'You’re Pro! 🎉';

  @override
  String get proThanksSubtitle => 'Thank you for supporting the app';

  @override
  String get proChecking => 'Checking Pro status…';

  @override
  String get proStatusUnavailable => 'Status unavailable — tap to manage';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get appVersion => 'App version';

  @override
  String get mvp => '1.0.0 (MVP)';

  @override
  String get titleLabel => 'Title';

  @override
  String get newCountdown => 'New Countdown';

  @override
  String get editCountdownFull => 'Edit Countdown';

  @override
  String get saveCountdown => 'Save Countdown';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get reminders => 'Reminders';

  @override
  String daysBeforeEvent(Object days) {
    return 'Days before event';
  }

  @override
  String get customReminder => 'Custom reminder';

  @override
  String get customPlus => '+ Custom';

  @override
  String get add => 'Add';

  @override
  String get deleted => 'Deleted';

  @override
  String get deleteCountdownQ => 'Delete countdown?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get countdownDetail => 'Countdown Detail';

  @override
  String get eventNotFound => 'Event not found';

  @override
  String get notificationStatus => 'Notification Status';

  @override
  String get ok => 'OK';

  @override
  String get share => 'Share';

  @override
  String shareTitleDate(Object date, Object title) {
    return 'Share: $title - $date';
  }

  @override
  String shareTitleIso(Object dateIso, Object title) {
    return 'Share: $title • $dateIso';
  }

  @override
  String scheduledInMinutes(Object minutes) {
    return 'Scheduled in $minutes min';
  }

  @override
  String scheduledInSeconds(Object seconds) {
    return 'Scheduled in $seconds sec';
  }

  @override
  String get dueToday => 'Today';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0 left';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0 ago';
  }

  @override
  String get exampleEventHint => 'e.g. Birthday Party';

  @override
  String get dateLabel => 'Date';

  @override
  String get iconLabel => 'Icon';

  @override
  String get egTen => 'e.g. 10';

  @override
  String get enterTitle => 'Please enter a title';

  @override
  String get chooseDate => 'Please choose a date';

  @override
  String get enterPositiveDays => 'Please enter 1 or more days';

  @override
  String get countdownAdded => 'Countdown added';

  @override
  String get paywallUnlockTitle => 'Unlock Pro';

  @override
  String get paywallSubtitle =>
      'Unlock Pro for unlimited events, exclusive themes, and an ad-free experience.';

  @override
  String get paywallFeatureHeader => 'Feature';

  @override
  String get paywallFreeColumn => 'Free';

  @override
  String get paywallProColumn => 'Pro';

  @override
  String get paywallFeatureEventLimit => 'Event limit';

  @override
  String get paywallFeatureThemes => 'Themes';

  @override
  String get paywallFeatureAdFree => 'Ad-free';

  @override
  String get paywallEventLimitPro => 'Unlimited';

  @override
  String get paywallThemeFree => 'Basic';

  @override
  String get paywallThemePro => 'Exclusive';

  @override
  String get paywallAdFreeFree => 'No';

  @override
  String get paywallAdFreePro => 'Yes';

  @override
  String get paywallAlreadyPro => 'You already have Pro';

  @override
  String get paywallProcessing => 'Processing...';

  @override
  String get paywallPurchaseSuccess => 'Pro unlocked!';

  @override
  String get paywallPurchaseCancelled => 'Purchase cancelled';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Purchase failed: $error';
  }

  @override
  String paywallOneTimePrice(String price) {
    return 'One-time purchase $price';
  }

  @override
  String get paywallRestoreSuccess => 'Purchases restored';

  @override
  String paywallRestoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String paywallGenericError(String message) {
    return 'Something went wrong.\n$message';
  }
}
