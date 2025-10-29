import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Countdowns'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColor;

  /// No description provided for @noCountdownsMsg.
  ///
  /// In en, this message translates to:
  /// **'You have no countdowns yet!'**
  String get noCountdownsMsg;

  /// No description provided for @addCountdown.
  ///
  /// In en, this message translates to:
  /// **'Add countdown'**
  String get addCountdown;

  /// No description provided for @editCountdown.
  ///
  /// In en, this message translates to:
  /// **'Edit countdown'**
  String get editCountdown;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @optionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Optional notes'**
  String get optionalNotes;

  /// No description provided for @createFirst.
  ///
  /// In en, this message translates to:
  /// **'Create your first countdown to get started🎉'**
  String get createFirst;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @upgradePro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradePro;

  /// No description provided for @proThanks.
  ///
  /// In en, this message translates to:
  /// **'You’re Pro! 🎉'**
  String get proThanks;

  /// No description provided for @proThanksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting the app'**
  String get proThanksSubtitle;

  /// No description provided for @proChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking Pro status…'**
  String get proChecking;

  /// No description provided for @proStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable — tap to manage'**
  String get proStatusUnavailable;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @mvp.
  ///
  /// In en, this message translates to:
  /// **'1.0.0 (MVP)'**
  String get mvp;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @newCountdown.
  ///
  /// In en, this message translates to:
  /// **'New Countdown'**
  String get newCountdown;

  /// No description provided for @editCountdownFull.
  ///
  /// In en, this message translates to:
  /// **'Edit Countdown'**
  String get editCountdownFull;

  /// No description provided for @saveCountdown.
  ///
  /// In en, this message translates to:
  /// **'Save Countdown'**
  String get saveCountdown;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @daysBeforeEvent.
  ///
  /// In en, this message translates to:
  /// **'Days before event'**
  String daysBeforeEvent(Object days);

  /// No description provided for @customReminder.
  ///
  /// In en, this message translates to:
  /// **'Custom reminder'**
  String get customReminder;

  /// No description provided for @customPlus.
  ///
  /// In en, this message translates to:
  /// **'+ Custom'**
  String get customPlus;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @deleteCountdownQ.
  ///
  /// In en, this message translates to:
  /// **'Delete countdown?'**
  String get deleteCountdownQ;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotBeUndone;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @countdownDetail.
  ///
  /// In en, this message translates to:
  /// **'Countdown Detail'**
  String get countdownDetail;

  /// No description provided for @eventNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found'**
  String get eventNotFound;

  /// No description provided for @notificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Notification Status'**
  String get notificationStatus;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareTitleDate.
  ///
  /// In en, this message translates to:
  /// **'Share: {title} - {date}'**
  String shareTitleDate(Object date, Object title);

  /// No description provided for @shareTitleIso.
  ///
  /// In en, this message translates to:
  /// **'Share: {title} • {dateIso}'**
  String shareTitleIso(Object dateIso, Object title);

  /// No description provided for @scheduledInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Scheduled in {minutes} min'**
  String scheduledInMinutes(Object minutes);

  /// No description provided for @scheduledInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Scheduled in {seconds} sec'**
  String scheduledInSeconds(Object seconds);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dueToday;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} day} other {{count} days}} left'**
  String daysLeft(num count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} day} other {{count} days}} ago'**
  String daysAgo(num count);

  /// No description provided for @exampleEventHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Birthday Party'**
  String get exampleEventHint;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @iconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get iconLabel;

  /// No description provided for @egTen.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get egTen;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get enterTitle;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Please choose a date'**
  String get chooseDate;

  /// No description provided for @enterPositiveDays.
  ///
  /// In en, this message translates to:
  /// **'Please enter 1 or more days'**
  String get enterPositiveDays;

  /// No description provided for @countdownAdded.
  ///
  /// In en, this message translates to:
  /// **'Countdown added'**
  String get countdownAdded;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro'**
  String get paywallUnlockTitle;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro for unlimited events, exclusive themes, and an ad-free experience.'**
  String get paywallSubtitle;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get paywallFeatureHeader;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get paywallFreeColumn;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get paywallProColumn;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Event limit'**
  String get paywallFeatureEventLimit;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get paywallFeatureThemes;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Ad-free'**
  String get paywallFeatureAdFree;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get paywallEventLimitPro;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get paywallThemeFree;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Exclusive'**
  String get paywallThemePro;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get paywallAdFreeFree;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get paywallAdFreePro;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'You already have Pro'**
  String get paywallAlreadyPro;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get paywallProcessing;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Pro unlocked!'**
  String get paywallPurchaseSuccess;

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled'**
  String get paywallPurchaseCancelled;

  /// Shown when the purchase flow fails with an error.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed: {error}'**
  String paywallPurchaseFailed(String error);

  /// Label showing the one-time purchase price for Pro.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase {price}'**
  String paywallOneTimePrice(String price);

  /// Paywall copy.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get paywallRestoreSuccess;

  /// Shown when the restore purchases flow fails with an error.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String paywallRestoreFailed(String error);

  /// Error message displayed with details when loading the paywall fails.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.\n{message}'**
  String paywallGenericError(String message);

  /// Message shown when the user has reached the free event cap.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your free limit ({cap}). Unlock Pro for unlimited events.'**
  String freeCapBannerAtLimit(int cap);

  /// Message showing how many free events remain before hitting the cap.
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} left on the free plan. Upgrade for unlimited events.'**
  String freeCapBannerRemaining(int remaining);

  /// Upgrade button label for the free cap banner.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get freeCapBannerUpgrade;

  /// Label for a reminder set 1 day before the event.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get reminderOffsetOneDay;

  /// Label for a reminder set 3 days before the event.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get reminderOffsetThreeDays;

  /// Label for a reminder set 1 week before the event.
  ///
  /// In en, this message translates to:
  /// **'1 week before'**
  String get reminderOffsetOneWeek;

  /// Label for a reminder set 1 month before the event.
  ///
  /// In en, this message translates to:
  /// **'1 month before'**
  String get reminderOffsetOneMonth;

  /// Label for a reminder set a specified number of days before the event.
  ///
  /// In en, this message translates to:
  /// **'{days} days before'**
  String reminderOffsetDays(int days);

  /// Title for the generic route error screen.
  ///
  /// In en, this message translates to:
  /// **'Route Error'**
  String get routeErrorTitle;

  /// Message shown when a route is missing the expected eventId argument.
  ///
  /// In en, this message translates to:
  /// **'Missing eventId for detail route.'**
  String get routeErrorMissingEvent;

  /// Label for the 1 day reminder preset chip.
  ///
  /// In en, this message translates to:
  /// **'1d'**
  String get reminderPresetOneDay;

  /// Label for the 3 day reminder preset chip.
  ///
  /// In en, this message translates to:
  /// **'3d'**
  String get reminderPresetThreeDays;

  /// Label for the 1 week reminder preset chip.
  ///
  /// In en, this message translates to:
  /// **'1w'**
  String get reminderPresetOneWeek;

  /// Label for the 1 month reminder preset chip.
  ///
  /// In en, this message translates to:
  /// **'1m'**
  String get reminderPresetOneMonth;

  /// Notification channel name for countdown reminders.
  ///
  /// In en, this message translates to:
  /// **'Countdown reminders'**
  String get notificationChannelName;

  /// Notification channel description for countdown reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders for upcoming countdown events.'**
  String get notificationChannelDescription;

  /// Notification title for upcoming countdowns.
  ///
  /// In en, this message translates to:
  /// **'Upcoming: {title}'**
  String notificationTitleUpcoming(String title);

  /// Notification title for test/debug reminders.
  ///
  /// In en, this message translates to:
  /// **'Test: {title}'**
  String notificationTitleTest(String title);

  /// Notification body shown on the day of the event.
  ///
  /// In en, this message translates to:
  /// **'Today is {title}'**
  String notificationBodyToday(String title);

  /// Notification body showing days remaining until the event.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} day to go} other {{count} days to go}}'**
  String notificationBodyDays(int count);

  /// Notification body when one week remains.
  ///
  /// In en, this message translates to:
  /// **'1 week to go'**
  String get notificationBodyOneWeek;

  /// Notification body showing months remaining until the event.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} month to go} other {{count} months to go}}'**
  String notificationBodyMonths(int count);

  /// Notification body for immediate debug notification.
  ///
  /// In en, this message translates to:
  /// **'Immediate notification'**
  String get notificationDebugImmediate;

  /// Notification body for scheduled debug notification.
  ///
  /// In en, this message translates to:
  /// **'Test reminder - fires at {time}'**
  String notificationDebugScheduled(String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
