import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:christmas_winter_theme/services/ringtone_config_service.dart';

void main() {
  group('RingtoneConfigService', () {
    late RingtoneConfigService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = RingtoneConfigService(
        prefsFactory: SharedPreferences.getInstance,
      );
    });

    test('returns null when no custom path exists', () async {
      final path = await service.getCustomPathInstance('1');
      expect(path, isNull);
    });

    test('saves and retrieves custom path', () async {
      await service.setCustomPathInstance('1', '/path/to/custom.mp3');
      final path = await service.getCustomPathInstance('1');
      expect(path, '/path/to/custom.mp3');
    });

    test('removes custom path when set to null', () async {
      await service.setCustomPathInstance('1', '/path/to/custom.mp3');
      await service.setCustomPathInstance('1', null);
      final path = await service.getCustomPathInstance('1');
      expect(path, isNull);
    });

    test('removes custom path when set to empty string', () async {
      await service.setCustomPathInstance('1', '/path/to/custom.mp3');
      await service.setCustomPathInstance('1', '');
      final path = await service.getCustomPathInstance('1');
      expect(path, isNull);
    });

    test('getAllOverrides returns all saved overrides', () async {
      await service.setCustomPathInstance('1', '/path/one.mp3');
      await service.setCustomPathInstance('5', '/path/five.mp3');
      await service.setCustomPathInstance('10', '/path/ten.mp3');

      final overrides = await service.getAllOverridesInstance();
      expect(overrides.length, 3);
      expect(overrides['1'], '/path/one.mp3');
      expect(overrides['5'], '/path/five.mp3');
      expect(overrides['10'], '/path/ten.mp3');
    });

    test('getAllOverrides returns empty map when none set', () async {
      final overrides = await service.getAllOverridesInstance();
      expect(overrides, isEmpty);
    });
  });
}
