# Changelog

All notable changes to this project will be documented in this file.

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
