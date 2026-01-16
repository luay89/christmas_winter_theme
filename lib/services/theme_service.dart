import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_themes.dart';
import '../utils/app_logger.dart';

/// Service for persisting and retrieving theme preferences.
/// 
/// This service is designed to be injectable (not static singleton).
/// Maintains backward compatibility with static methods during migration.
class ThemeService {
  static const String _themeKey = 'selected_theme';
  
  final Future<SharedPreferences> Function() _prefsFactory;

  /// Creates a new instance of ThemeService.
  /// 
  /// For production use, use the default constructor.
  /// For testing, inject a mock SharedPreferences factory.
  ThemeService({Future<SharedPreferences> Function()? prefsFactory})
      : _prefsFactory = prefsFactory ?? SharedPreferences.getInstance;

  /// Default singleton instance for backward compatibility during migration.
  /// TODO: Remove after full dependency injection implementation.
  static final ThemeService _instance = ThemeService();
  static ThemeService get instance => _instance;

  Future<ThemeStyle> getSelectedThemeInstance() async {
    try {
      final prefs = await _prefsFactory();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      if (themeIndex >= 0 && themeIndex < ThemeStyle.values.length) {
        final theme = ThemeStyle.values[themeIndex];
        AppLogger.debug('Loaded theme: ${theme.name}');
        return theme;
      }
      AppLogger.warning('Invalid theme index: $themeIndex, using default');
      return ThemeStyle.classicChristmas;
    } catch (e, stack) {
      AppLogger.error('Error loading theme', error: e, stackTrace: stack);
      return ThemeStyle.classicChristmas;
    }
  }

  Future<void> setSelectedThemeInstance(ThemeStyle theme) async {
    try {
      final prefs = await _prefsFactory();
      await prefs.setInt(_themeKey, theme.index);
      AppLogger.info('Theme saved: ${theme.name}');
    } catch (e, stack) {
      AppLogger.error('Error saving theme', error: e, stackTrace: stack);
    }
  }

  // ============================================
  // LEGACY STATIC METHODS (for backward compatibility)
  // ============================================

  static Future<ThemeStyle> getSelectedTheme() =>
      _instance.getSelectedThemeInstance();

  static Future<void> setSelectedTheme(ThemeStyle theme) =>
      _instance.setSelectedThemeInstance(theme);
}

