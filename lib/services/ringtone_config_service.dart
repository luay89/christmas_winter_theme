import 'package:shared_preferences/shared_preferences.dart';

class RingtoneConfigService {
  static String _keyFor(String id) => 'ringtone_override_$id';

  static Future<String?> getCustomPath(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyFor(id));
    } catch (e) {
      print('Error reading ringtone override for $id: $e');
      return null;
    }
  }

  static Future<void> setCustomPath(String id, String? path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _keyFor(id);
      if (path == null || path.isEmpty) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, path);
      }
    } catch (e) {
      print('Error saving ringtone override for $id: $e');
    }
  }

  static Future<Map<String, String>> getAllOverrides() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = <String, String>{};
      for (final key in prefs.getKeys()) {
        if (key.startsWith('ringtone_override_')) {
          final id = key.substring('ringtone_override_'.length);
          final val = prefs.getString(key);
          if (val != null) map[id] = val;
        }
      }
      return map;
    } catch (e) {
      print('Error getting all ringtone overrides: $e');
      return {};
    }
  }
}
