import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_logger.dart';

/// Service for storing custom ringtone path overrides.
/// 
/// This service is designed to be injectable (not static singleton).
/// Maintains backward compatibility with static methods during migration.
class RingtoneConfigService {
  final Future<SharedPreferences> Function() _prefsFactory;

  /// Creates a new instance of RingtoneConfigService.
  RingtoneConfigService({Future<SharedPreferences> Function()? prefsFactory})
      : _prefsFactory = prefsFactory ?? SharedPreferences.getInstance;

  /// Default singleton instance for backward compatibility.
  static final RingtoneConfigService _instance = RingtoneConfigService();
  static RingtoneConfigService get instance => _instance;

  String _keyFor(String id) => 'ringtone_override_$id';

  Future<String?> getCustomPathInstance(String id) async {
    try {
      final prefs = await _prefsFactory();
      final path = prefs.getString(_keyFor(id));
      if (path != null) {
        AppLogger.debug('Custom path for ringtone $id: $path');
      }
      return path;
    } catch (e, stack) {
      AppLogger.error('Error reading ringtone override for $id', error: e, stackTrace: stack);
      return null;
    }
  }

  Future<void> setCustomPathInstance(String id, String? path) async {
    try {
      final prefs = await _prefsFactory();
      final key = _keyFor(id);
      if (path == null || path.isEmpty) {
        await prefs.remove(key);
        AppLogger.info('Removed custom path for ringtone $id');
      } else {
        await prefs.setString(key, path);
        AppLogger.info('Set custom path for ringtone $id: $path');
      }
    } catch (e, stack) {
      AppLogger.error('Error saving ringtone override for $id', error: e, stackTrace: stack);
    }
  }

  Future<Map<String, String>> getAllOverridesInstance() async {
    try {
      final prefs = await _prefsFactory();
      final map = <String, String>{};
      for (final key in prefs.getKeys()) {
        if (key.startsWith('ringtone_override_')) {
          final id = key.substring('ringtone_override_'.length);
          final val = prefs.getString(key);
          if (val != null) map[id] = val;
        }
      }
      AppLogger.debug('Loaded ${map.length} ringtone overrides');
      return map;
    } catch (e, stack) {
      AppLogger.error('Error getting all ringtone overrides', error: e, stackTrace: stack);
      return {};
    }
  }

  // ============================================
  // LEGACY STATIC METHODS (for backward compatibility)
  // ============================================

  static Future<String?> getCustomPath(String id) =>
      _instance.getCustomPathInstance(id);

  static Future<void> setCustomPath(String id, String? path) =>
      _instance.setCustomPathInstance(id, path);

  static Future<Map<String, String>> getAllOverrides() =>
      _instance.getAllOverridesInstance();
}
