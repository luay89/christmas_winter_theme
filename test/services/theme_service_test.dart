import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:christmas_winter_theme/services/theme_service.dart';
import 'package:christmas_winter_theme/theme/app_themes.dart';

void main() {
  group('ThemeService', () {
    late ThemeService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = ThemeService(prefsFactory: SharedPreferences.getInstance);
    });

    test('returns default theme when no preference set', () async {
      final theme = await service.getSelectedThemeInstance();
      expect(theme, ThemeStyle.classicChristmas);
    });

    test('saves and retrieves theme correctly', () async {
      await service.setSelectedThemeInstance(ThemeStyle.winterWonderland);
      final theme = await service.getSelectedThemeInstance();
      expect(theme, ThemeStyle.winterWonderland);
    });

    test('saves and retrieves all theme styles', () async {
      for (final style in ThemeStyle.values) {
        await service.setSelectedThemeInstance(style);
        final result = await service.getSelectedThemeInstance();
        expect(result, style, reason: 'Failed for ${style.name}');
      }
    });

    test('returns default theme for invalid index', () async {
      // Set an out-of-range index directly
      SharedPreferences.setMockInitialValues({'selected_theme': 999});
      service = ThemeService(prefsFactory: SharedPreferences.getInstance);
      final theme = await service.getSelectedThemeInstance();
      expect(theme, ThemeStyle.classicChristmas);
    });
  });
}
