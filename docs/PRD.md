<!-- countdown_app/docs/PRD.md -->
# Product Requirements Document (PRD)

## Overview
A JP-first, aesthetic countdown/reminder app with widgets and notifications.  
Users can create countdowns (concerts, trips, exams, birthdays, anime releases).  

- **Free users:** Up to 2 countdowns + ads.  
- **Pro unlock:** Unlimited countdowns, no ads, premium themes (one-time ¥1,200 JPY).  

## Target Markets
- **Primary:** Japan (localized UI, kawaii pastel/dark themes).  
- **Secondary:** US/UK/SEA/AU (English UI).  

## Core Features (MVP)
1. Create countdown (title, date, emoji/icon, notes).  
2. Countdown list (sorted by soonest).  
3. Countdown detail (big D-Day, share).  
4. Local notifications (7d, 1d, day-of).  
5. Widgets (small/medium, nearest event).  
6. Settings (theme, language toggle, upgrade).  
7. Paywall screen (Pro unlock).  
8. Localization (EN/JP).  

## User Journeys
- **First-time user:**  
  - Launch → (optional onboarding) → See empty list → Tap + → Add countdown → See it on list.  
- **Returning free user:**  
  - Opens app → List shows countdowns → Can tap detail → Add new event (blocked if ≥2).  
- **Free → Pro conversion:**  
  - User hits 2-event limit → Shown Paywall → Purchases Pro → Unlimited events + ad removal.  
- **Widget flow:**  
  - User adds widget to home screen → Widget shows nearest event countdown.  
- **Notification flow:**  
  - User enables reminders → App schedules notifications at 7d, 1d, and day-of.  

## Design Guidelines
- Minimalist + kawaii pastel, optional dark mode.  
- Fonts: Noto Sans JP / Rounded M+ (JP), Inter / Poppins (EN).  
- Animations: subtle fade/slide.  

## Monetization
- **Free tier:** 2 events, banner ad at bottom of main list.  
- **Pro unlock (one-time ¥1,200 JPY):**  
  - Unlimited events.  
  - Removes ads.  
  - Unlocks premium themes (sakura, dark mode, anime-inspired).  
- **Paywall Screen Copy:**  
  - JP: 「無制限のカウントダウンを作成」「広告なし」「特別テーマ」  
  - EN: “Unlimited countdowns”, “No ads”, “Exclusive themes”  
