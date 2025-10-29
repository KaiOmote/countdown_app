// lib/features/notifications/notification_service.dart

import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter/widgets.dart' show Locale, WidgetsBinding;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:countdown_app/l10n/app_localizations.dart';

import '../../../core/navigation/nav.dart';
import '../../../core/navigation/routes.dart';
import '../countdown/data/countdown_event.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'countdown_reminders';

  Future<void> initialize() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    await _configureLocalTimezone();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onTapNotification,
    );

    final l10n = _localizations();

    final androidChannel = AndroidNotificationChannel(
      _channelId,
      l10n.notificationChannelName,
      description: l10n.notificationChannelDescription,
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<void> ensurePermissions() async {
    await initialize();

    if (_isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final settings = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint('[Notif] iOS permission request result: $settings');
      }
    }

    if (_isAndroid && !kIsWeb) {
      final notifStatus = await Permission.notification.status;
      if (kDebugMode) {
        debugPrint(
          '[Notif] Android notification permission status: $notifStatus',
        );
      }
      if (!notifStatus.isGranted) {
        final requestResult = await Permission.notification.request();
        if (kDebugMode) {
          debugPrint(
            '[Notif] Android notification permission request: $requestResult',
          );
        }
      }

      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canExact = await androidPlugin?.canScheduleExactNotifications();
      if (kDebugMode) {
        debugPrint('[Notif] canScheduleExactNotifications -> $canExact');
      }
      if (canExact == false) {
        final exactPermission = await Permission.scheduleExactAlarm.status;
        if (kDebugMode) {
          debugPrint('[Notif] scheduleExactAlarm status: $exactPermission');
        }
        if (!exactPermission.isGranted) {
          final result = await Permission.scheduleExactAlarm.request();
          if (kDebugMode) {
            debugPrint('[Notif] scheduleExactAlarm request -> $result');
          }
        }
        final granted = await androidPlugin?.requestExactAlarmsPermission();
        if (kDebugMode) {
          debugPrint('[Notif] requestExactAlarmsPermission -> $granted');
        }
      }
    }

    final enabled = await _areNotificationsEnabled();
    if (kDebugMode) {
      debugPrint('[Notif] areNotificationsEnabled -> $enabled');
    }
  }

  Future<void> rescheduleForEvent(CountdownEvent event) async {
    await initialize();
    await ensurePermissions();

    await _cancelKnown(event);
    if (event.reminderOffsets.isEmpty) return;

    final l10n = _localizations();
    final details = _platformDetails(l10n);

    for (final offsetDays in event.reminderOffsets) {
      final scheduled = _computeTriggerLocal(event.dateUtc, offsetDays);
      if (scheduled == null) continue;

      final id = _notificationId(event.id, offsetDays);
      await _plugin.zonedSchedule(
        id,
        l10n.notificationTitleUpcoming(event.title),
        _bodyForOffset(l10n, offsetDays, event),
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: event.id,
      );

      if (kDebugMode) {
        debugPrint(
          '[Notif] Scheduled reminder id=$id at $scheduled for event=${event.id}',
        );
      }
    }
  }

  Future<void> showImmediateTest(String eventId, String title) async {
    await initialize();
    await ensurePermissions();

    final id = _debugNotificationId(eventId, Duration.zero);
    final l10n = _localizations();
    await _plugin.show(
      id,
      l10n.notificationTitleTest(title),
      l10n.notificationDebugImmediate,
      _platformDetails(l10n),
      payload: eventId,
    );

    if (kDebugMode) {
      debugPrint('[NotifDebug] showImmediateTest id=$id tz=${tz.local.name}');
    }
  }

  Future<void> showTestNotification(
    String eventId,
    String title,
    DateTime dateUtc,
    Duration offset,
  ) async {
    await initialize();
    await ensurePermissions();

    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(offset);
    final id = _debugNotificationId(eventId, offset);
    final l10n = _localizations();
    final notificationTitle = l10n.notificationTitleUpcoming(title);
    final scheduledBody = l10n.notificationDebugScheduled(
      _formatTime(scheduled),
    );
    final details = _platformDetails(l10n);

    var mode = await _preferredAndroidScheduleMode(exact: true);
    try {
      await _plugin.zonedSchedule(
        id,
        notificationTitle,
        scheduledBody,
        scheduled,
        details,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: eventId,
      );
    } on PlatformException catch (err) {
      final triedExact = mode == AndroidScheduleMode.exactAllowWhileIdle;
      if (triedExact && _isAndroid) {
        mode = AndroidScheduleMode.inexactAllowWhileIdle;
        if (kDebugMode) {
          debugPrint(
            '[NotifDebug] exact alarm denied ($err), retrying inexact',
          );
        }
        await _plugin.zonedSchedule(
          id,
          notificationTitle,
          l10n.notificationDebugScheduled(_formatTime(scheduled)),
          scheduled,
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: eventId,
        );
      } else {
        rethrow;
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[NotifDebug] Scheduled test id=$id at $scheduled (now=$now, tz=${tz.local.name}) mode=$mode',
      );
    }
  }

  Future<void> cancelDebugForEvent(String eventId) async {
    final offsets = <Duration>[
      Duration.zero,
      const Duration(seconds: 30),
      const Duration(minutes: 1),
      const Duration(minutes: 2),
      const Duration(minutes: 3),
      const Duration(minutes: 5),
    ];
    for (final offset in offsets) {
      final id = _debugNotificationId(eventId, offset);
      await _plugin.cancel(id);
    }
  }

  Future<String> debugStatus() async {
    await initialize();
    final buffer = StringBuffer()
      ..writeln('=== Notifications Debug ===')
      ..writeln('Initialized: $_initialized')
      ..writeln('tz.local: ${tz.local.name}')
      ..writeln('Now: ${tz.TZDateTime.now(tz.local)}');

    final enabled = await _areNotificationsEnabled();
    buffer.writeln('Notifications enabled: $enabled');

    final pending = await _plugin.pendingNotificationRequests();
    buffer.writeln('Pending: ${pending.length}');
    for (final request in pending) {
      buffer.writeln(
        ' - [${request.id}] ${request.title} | ${request.body} (payload=${request.payload})',
      );
    }

    return buffer.toString();
  }

  Future<void> _configureLocalTimezone() async {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;
    final gmtLabel = _formatOffset(offset);

    final candidates = <String?>[
      gmtLabel,
      _findMatchingLocation(offset),
      _formatEtcName(offset),
      'Asia/Tokyo',
      'UTC',
    ];

    final errors = <String>[];
    String? resolvedName;

    for (final candidate in candidates) {
      if (candidate == null) continue;
      try {
        final location = tz.getLocation(candidate);
        tz.setLocalLocation(location);
        resolvedName = candidate;
        break;
      } catch (err) {
        errors.add('$candidate -> $err');
      }
    }

    if (resolvedName == null) {
      tz.setLocalLocation(tz.getLocation('UTC'));
      resolvedName = 'UTC';
    }

    if (kDebugMode) {
      debugPrint(
        '[Notif] system offset: ${_formatOffset(offset, withGmt: false)}',
      );
      debugPrint('[Notif] computed tz label: $gmtLabel');
      debugPrint(
        '[Notif] tz.local set: ${tz.local.name} (resolved=$resolvedName)',
      );
      if (errors.isNotEmpty) {
        debugPrint(
          '[Notif] timezone resolution fallbacks: ${errors.join('; ')}',
        );
      }
    }
  }

  Future<AndroidScheduleMode> _preferredAndroidScheduleMode({
    required bool exact,
  }) async {
    if (!_isAndroid || kIsWeb) {
      return exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    }

    if (!exact) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canExact = await androidPlugin?.canScheduleExactNotifications();
    if (kDebugMode) {
      debugPrint(
        '[Notif] preferred schedule mode exact=$exact canExact=$canExact',
      );
    }
    return canExact == false
        ? AndroidScheduleMode.inexactAllowWhileIdle
        : AndroidScheduleMode.exactAllowWhileIdle;
  }

  tz.TZDateTime? _computeTriggerLocal(DateTime eventUtc, int offsetDays) {
    if (offsetDays < 0) return null;

    final eventLocal = tz.TZDateTime.from(eventUtc, tz.local);
    final targetDate = tz.TZDateTime(
      tz.local,
      eventLocal.year,
      eventLocal.month,
      eventLocal.day,
    ).subtract(Duration(days: offsetDays));

    final scheduled = tz.TZDateTime(
      tz.local,
      targetDate.year,
      targetDate.month,
      targetDate.day,
      9,
    );

    final nowLocal = tz.TZDateTime.now(tz.local);
    if (!scheduled.isAfter(nowLocal)) {
      if (kDebugMode) {
        debugPrint(
          '[Notif] Skipping past reminder at $scheduled for event=${eventUtc.toIso8601String()}',
        );
      }
      return null;
    }
    return scheduled;
  }

  NotificationDetails _platformDetails(AppLocalizations l10n) {
    final android = AndroidNotificationDetails(
      _channelId,
      l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  int _notificationId(String eventId, int offsetDays) {
    return Object.hash(eventId, offsetDays) & 0x7fffffff;
  }

  int _debugNotificationId(String eventId, Duration offset) {
    return Object.hash(eventId, offset.inSeconds) ^ 0x59d2;
  }

  String _bodyForOffset(
    AppLocalizations l10n,
    int offset,
    CountdownEvent event,
  ) {
    if (offset <= 0) return l10n.notificationBodyToday(event.title);
    if (offset == 7) return l10n.notificationBodyOneWeek;
    if (offset >= 30 && offset % 30 == 0) {
      final months = offset ~/ 30;
      return l10n.notificationBodyMonths(months);
    }
    return l10n.notificationBodyDays(offset);
  }

  Future<void> _cancelKnown(CountdownEvent event) async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.payload == event.id) {
        await _plugin.cancel(request.id);
      }
    }
  }

  void _onTapNotification(NotificationResponse response) {
    final eventId = response.payload;
    if (eventId == null || eventId.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rootNavigatorKey.currentState?.pushNamed(
        Routes.countdownDetail,
        arguments: eventId,
      );
    });
  }

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<bool?> _areNotificationsEnabled() async {
    if (_isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return androidPlugin?.areNotificationsEnabled();
    }

    if (_isIOS) {
      // Optional: implement iOS check if needed (Darwin plugin has limited support)
      // Returning true means permissions were requested/granted earlier
      return true;
    }

    return null;
  }

  String _formatOffset(Duration offset, {bool withGmt = true}) {
    final sign = offset.isNegative ? '-' : '+';
    final abs = offset.abs();
    final hours = abs.inHours.toString().padLeft(2, '0');
    final minutes = (abs.inMinutes % 60).toString().padLeft(2, '0');
    final prefix = withGmt ? 'GMT' : '';
    return '$prefix$sign$hours:$minutes';
  }

  String? _formatEtcName(Duration offset) {
    if (offset.inMinutes % 60 != 0) return null;
    final hours = offset.inHours.abs();
    final sign = offset.isNegative ? '+' : '-';
    return 'Etc/GMT$sign$hours';
  }

  String _formatTime(tz.TZDateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String? _findMatchingLocation(Duration offset) {
    final utcNow = DateTime.now().toUtc();
    for (final entry in tz.timeZoneDatabase.locations.entries) {
      final location = entry.value;
      final localTime = tz.TZDateTime.from(utcNow, location);
      if (localTime.timeZoneOffset == offset) {
        return entry.key;
      }
    }
    return null;
  }

  AppLocalizations _localizations() {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final locale = dispatcher.locale;
    final supported = AppLocalizations.supportedLocales.firstWhere(
      (l) => l.languageCode == locale.languageCode,
      orElse: () => AppLocalizations.supportedLocales.first,
    );
    return lookupAppLocalizations(supported);
  }
}
