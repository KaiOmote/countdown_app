<!-- countdown_app/docs/FILE_STRUCTURE.md -->
# File/Folder Structure (Locked Baseline)

lib/
├─ core/
│ ├─ navigation/routes.dart
│ ├─ theme/{colors.dart, typography.dart, themes.dart}
│ ├─ utils/{gaps.dart, formatters.dart, constants.dart}
│ └─ app.dart
├─ features/
│ ├─ countdown/
│ │ ├─ data/{countdown_event.dart, countdown_repository.dart}
│ │ ├─ presentation/{countdown_list_screen.dart, countdown_detail_screen.dart, add_edit_countdown_screen.dart}
│ │ └─ providers.dart
│ ├─ settings/
│ │ ├─ presentation/settings_screen.dart
│ │ ├─ paywall_screen.dart
│ │ ├─ iap_service.dart
│ │ └─ theme_provider.dart
│ ├─ notifications/notification_service.dart
│ ├─ widgets/widget_service.dart
│ └─ onboarding/onboarding_screen.dart (optional)
├─ widgets/{countdown_card.dart, app_button.dart, app_text_field.dart}
└─ main.dart