# GlucoseSync

GlucoseSync is a cross-platform Flutter app for logging meals, insulin, and blood sugar readings with offline-first storage and Google Sheets sync support.

## Features
- Meal, insulin, and glucose logging
- Clinical post-meal timing guidance
- Offline-first Hive storage
- Dashboard summaries and history views
- Google Sheets sync placeholder ready for service-account integration

## Setup
1. Run `flutter pub get`
2. Run `flutter run`
3. For Google Sheets sync, provide credentials via a service account JSON and wire the implementation in `lib/features/sync/google_sheets_sync_service.dart`.
