# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - 2026-02-15

### Added

#### Animated Snow Effect
- New `lib/widgets/animated_snow.dart` — GPU-efficient animated falling snowflakes overlay
  - Uses `AnimationController` + `CustomPainter` with particle system
  - Configurable `snowflakeCount` and `opacity` parameters
- Integrated into `home_page.dart` replacing static SnowPainter
- Integrated into `ringtone_detail_page.dart` SliverAppBar background

#### Ringtone Detail Page
- New `lib/pages/ringtone_detail_page.dart` — full-screen ringtone player
  - Progress `Slider` with real-time position/duration tracking
  - Play/pause/stop controls with gradient circular play button
  - "Set as ringtone" and "Set as notification" action buttons
  - Category icon display and ringtone description card
  - Animated snow overlay in the app bar
- Long-press on `RingtoneCard` navigates to detail page

#### Playback Progress Bar
- Added inline `LinearProgressIndicator` in `RingtoneCard` widget
  - Shows real-time playback progress below the card content
  - Position and duration `StreamSubscription`s with proper lifecycle management

#### Provider Dependency Injection
- Added `provider: ^6.1.1` to dependencies
- New `lib/services/service_providers.dart` — `MultiProvider` wrapper for all 5 services
  - `AudioService`, `ThemeService`, `MobileThemeService`, `DownloadService`, `RingtoneConfigService`
  - Proper `dispose` callbacks for `AudioService` and `DownloadService`
- Updated `lib/main.dart` to wrap app with `ServiceProviders`

#### Unit Tests (39 tests)
- `test/services/theme_service_test.dart` — save/retrieve theme, invalid index handling
- `test/services/ringtone_config_service_test.dart` — custom paths CRUD, getAllOverrides
- `test/services/download_service_test.dart` — URL validation (HTTPS, localhost, private IPs), filename validation
- `test/services/mobile_theme_service_test.dart` — PlatformOperationResult factories, empty path rejection
- `test/models_test.dart` — Ringtone/MobileTheme model integrity, AudioHelper validation

#### Theme Change Permissions
- New `lib/utils/permission_helper.dart` — WRITE_SETTINGS permission check with user-friendly dialog
  - Arabic-language dialog explaining why the permission is needed
  - Opens system app settings for granting the permission
  - Integrated into `ringtone_detail_page.dart` `_setAs()` method
  - Integrated into `mobile_themes_page.dart` `_applyTheme()` method
  - Blocks ringtone/notification setting until permission flow completes

#### Placeholder Audio Assets
- Added 12 silent placeholder MP3 files in `assets/audio/` to prevent asset-loading crashes
  - `jingle_bells.mp3`, `silent_night.mp3`, `deck_the_halls.mp3`, `merry_christmas.mp3`
  - `santa_claus.mp3`, `frosty_snowman.mp3`, `let_it_snow.mp3`, `winter_wonderland.mp3`
  - `christmas_bells.mp3`, `joy_to_world.mp3`, `snowflake.mp3`, `new_year.mp3`
  - These are ~16KB silent placeholders — replace with real audio files for production

### Changed

#### ThemeData Refactor
- Reduced 5 identical theme getter methods (~120 lines) to single `_buildTheme(ColorScheme)` factory
- Added `navigationBarTheme` and `sliderTheme` to unified builder
- `getTheme()` now calls `_buildTheme(getColorScheme(style))`

#### Lint & Code Quality (25 issues → 0)
- Replaced `print()` with `AppLogger.error()` in `lib/pages/home_page.dart` and `lib/pages/mobile_themes_page.dart` (avoid_print)
- Replaced 19 deprecated `withOpacity()` calls with `withValues(alpha:)` across all UI files (deprecated_member_use)
- Removed unused `app_logger.dart` import from `lib/widgets/ringtone_card.dart` (unused_import)
- Fixed `use_build_context_synchronously` in `lib/widgets/ringtone_card.dart` — changed `if (mounted)` to `if (context.mounted)` after async gaps

#### Android WRITE_SETTINGS Permission Fix
- Removed `android:maxSdkVersion="22"` from `WRITE_SETTINGS` permission in `AndroidManifest.xml`
- Added `Settings.System.canWrite()` runtime check in `MainActivity.kt` before `setActualDefaultRingtoneUri()` for both ringtone and notification sound
- On Android 6+ without permission, now redirects to system settings instead of failing silently

## [Unreleased] - 2026-01-16

### Added

#### Governance Files
- `governance/AGENT_RULES.md` - Agent behavior constraints and coding standards
- `governance/SECURITY_POLICY.md` - Security requirements and prohibited practices
- `governance/ARCHITECTURE.md` - Layer definitions and architectural rules
- `governance/PROMPT_PROTOCOL.md` - Two-phase workflow protocol (Audit → Correction)

#### Utilities
- `lib/utils/app_logger.dart` - Structured logging utility replacing print() statements
- `lib/utils/platform_utils.dart` - Platform detection utilities for graceful guards

### Changed

#### Service Refactoring (Injectable Pattern)
All services refactored from static singletons to injectable classes while maintaining backward compatibility:

- **AudioService** (`lib/services/audio_service.dart`)
  - Converted to injectable class with `AudioPlayer` injection support
  - Added instance methods alongside legacy static methods
  - Replaced print() with AppLogger

- **ThemeService** (`lib/services/theme_service.dart`)
  - Converted to injectable class with `SharedPreferences` factory injection
  - Added instance methods alongside legacy static methods
  - Replaced print() with AppLogger

- **MobileThemeService** (`lib/services/mobile_theme_service.dart`)
  - Converted to injectable class with `MethodChannel` injection support
  - Added `PlatformOperationResult` class for structured operation results
  - Added platform guards (fails gracefully on non-Android platforms)
  - Added input validation for audio paths
  - Replaced print() with AppLogger

- **DownloadService** (`lib/services/download_service.dart`)
  - Converted to injectable class with `http.Client` injection support
  - Added URL validation (HTTPS only, no localhost/internal networks)
  - Added file size limit (10 MB max)
  - Added filename validation
  - Replaced print() with AppLogger

- **RingtoneConfigService** (`lib/services/ringtone_config_service.dart`)
  - Converted to injectable class with `SharedPreferences` factory injection
  - Added instance methods alongside legacy static methods
  - Replaced print() with AppLogger

#### Global Error Handling
- `lib/main.dart`
  - Added `runZonedGuarded` for catching uncaught async errors
  - Added `FlutterError.onError` for Flutter framework errors
  - Added `PlatformDispatcher.instance.onError` for platform errors
  - Replaced print() with AppLogger

### Fixed

#### Memory Leak
- `lib/widgets/ringtone_card.dart`
  - Added `StreamSubscription` field to track audio player state subscription
  - Added proper cleanup in `dispose()` method to cancel subscription

### Security

- Platform channels now fail gracefully with user-friendly error messages
- Download service validates URLs (HTTPS only)
- Download service blocks localhost and internal network URLs
- Download service enforces file size limits
- Input validation added to all platform channel methods
