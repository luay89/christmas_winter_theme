import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_themes.dart';

class ThemeService {
  static const String _themeKey = 'selected_theme';

  static Future<ThemeStyle> getSelectedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      if (themeIndex >= 0 && themeIndex < ThemeStyle.values.length) {
        return ThemeStyle.values[themeIndex];
      }
      return ThemeStyle.classicChristmas;
    } catch (e) {
      print('خطأ في تحميل الثيم: $e');
      return ThemeStyle.classicChristmas;
    }
  }

  static Future<void> setSelectedTheme(ThemeStyle theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      print('خطأ في حفظ الثيم: $e');
    }
  }
}

