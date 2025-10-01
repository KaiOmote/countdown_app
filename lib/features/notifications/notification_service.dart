// lib/features/notifications/notification_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../countdown/data/countdown_event.dart';

/// Singleton NotificationService for scheduling/canceling reminders.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Android channel IDs
  static const String _channelId = 'countdown_reminders';
  static const String _channelName = 'Countdown Reminders';
  static const String _channelDesc = 'Reminders for upcoming countdown events';

  /// Call once, early in app startup (before runApp).
  Future<void> initialize() async {
    if (_initialized) return;

    // Timezone init
    tzdata.initializeTimeZones();
    // Using tz.local as provided by the device; no explicit setLocalLocation needed.

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onTapNotification,
    );

    // Create Android channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.defaultImportance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  /// Ask the user for permissions where needed.
  ///
  /// iOS: request runtime notification permissions.
  /// Android: we skip explicit runtime requests here to avoid API mismatch;
  ///          most devices are fine. We can add a Settings toggle later.
  Future<void> ensurePermissions() async {
    // iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // ANDROID NOTE:
    // Some plugin versions expose requestPermission() or requestNotificationsPermission()
    // on Android, others don't. To keep compile-safe across versions, we skip it here.
    // If you want an explicit permission flow for Android 13+, we’ll add it later
    // behind a settings toggle and handle it with a version check.
  }

  /// Cancel & reschedule all reminders for this event to match current offsets.
  /// To cancel everything, call with event.copyWith(reminderOffsets: []).
  Future<void> rescheduleForEvent(CountdownEvent event) async {
    await initialize();
    await ensurePermissions();

    // Cancel any existing scheduled notifications for this event ID.
    await _cancelKnown(event);

    if (event.reminderOffsets.isEmpty) return;

    for (final offsetDays in event.reminderOffsets) {
      final schedule = _computeTriggerLocal(event.dateUtc, offsetDays);

      if (schedule == null) continue; // in the past -> skip

      final nid = _notificationId(event.id, offsetDays);
      final details = _platformDetails();

      await _plugin.zonedSchedule(
        nid,
        // Title
        '⏰ ${event.title}',
        // Body
        _bodyForOffset(offsetDays, event),
        schedule,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: event.id, // later we can deep-link using this
      );
    }
  }

  /// Compute a 09:00 local trigger time for [eventUtc - offsetDays].
  tz.TZDateTime? _computeTriggerLocal(DateTime eventUtc, int offsetDays) {
    // Event stored as UTC. Convert to local date (drop time-of-day), then subtract days.
    final local = eventUtc.toLocal();
    final eventLocalDate = DateTime(local.year, local.month, local.day);
    final remindLocalDate =
        eventLocalDate.subtract(Duration(days: offsetDays));

    // Schedule at 09:00 local on that day.
    final scheduled = tz.TZDateTime(
      tz.local,
      remindLocalDate.year,
      remindLocalDate.month,
      remindLocalDate.day,
      9,
      0,
    );

    // for instant testing replace above scheduled var with below commented code
    // final scheduled = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));


    // If it's already past, skip.
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      return null;
    }
    return scheduled;
  }

  NotificationDetails _platformDetails() {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    return const NotificationDetails(android: android, iOS: iOS);
  }

  int _notificationId(String eventId, int offsetDays) {
    // Stable hash for eventId + offset
    final base = eventId.hashCode ^ (offsetDays * 1315423911);
    return base & 0x7fffffff; // positive int
  }

  String _bodyForOffset(int offset, CountdownEvent e) {
    if (offset <= 0) return 'Today is ${e.title}';
    if (offset == 1) return '1 day to go';
    if (offset == 3) return '3 days to go';
    if (offset == 7) return '1 week to go';
    if (offset >= 30 && offset % 30 == 0) return '${(offset ~/ 30)} month(s) to go';
    return '$offset days to go';
  }

  Future<void> _cancelKnown(CountdownEvent event) async {
    for (final offset in event.reminderOffsets) {
      final id = _notificationId(event.id, offset);
      await _plugin.cancel(id);
    }
  }

  void _onTapNotification(NotificationResponse response) {
    // NOTE: later we can deep-link to detail using response.payload (eventId)
    if (kDebugMode) {
      debugPrint('Tapped notification payload: ${response.payload}');
    }
  }
}
