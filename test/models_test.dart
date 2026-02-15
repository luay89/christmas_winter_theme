import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_winter_theme/models/ringtone.dart';
import 'package:christmas_winter_theme/models/mobile_theme.dart';
import 'package:christmas_winter_theme/utils/audio_helper.dart';

void main() {
  group('Ringtone Model', () {
    test('getChristmasRingtones returns 12 ringtones', () {
      final ringtones = Ringtone.getChristmasRingtones();
      expect(ringtones.length, 12);
    });

    test('all ringtones have valid audio paths', () {
      final ringtones = Ringtone.getChristmasRingtones();
      for (final r in ringtones) {
        expect(r.audioPath, startsWith('assets/audio/'));
        expect(r.audioPath, endsWith('.mp3'));
      }
    });

    test('all ringtones have unique IDs', () {
      final ringtones = Ringtone.getChristmasRingtones();
      final ids = ringtones.map((r) => r.id).toSet();
      expect(ids.length, ringtones.length);
    });

    test('all ringtones have non-empty fields', () {
      final ringtones = Ringtone.getChristmasRingtones();
      for (final r in ringtones) {
        expect(r.id, isNotEmpty);
        expect(r.title, isNotEmpty);
        expect(r.category, isNotEmpty);
        expect(r.audioPath, isNotEmpty);
        expect(r.description, isNotEmpty);
      }
    });
  });

  group('MobileTheme Model', () {
    test('getChristmasThemes returns 6 themes', () {
      final themes = MobileTheme.getChristmasThemes();
      expect(themes.length, 6);
    });

    test('all themes have unique IDs', () {
      final themes = MobileTheme.getChristmasThemes();
      final ids = themes.map((t) => t.id).toSet();
      expect(ids.length, themes.length);
    });

    test('all themes reference valid ringtone IDs', () {
      final themes = MobileTheme.getChristmasThemes();
      final validIds = Ringtone.getChristmasRingtones()
          .map((r) => r.id)
          .toSet();

      for (final theme in themes) {
        for (final id in theme.ringtoneIds) {
          expect(
            validIds.contains(id),
            isTrue,
            reason: 'Theme ${theme.id} references invalid ringtone ID: $id',
          );
        }
      }
    });

    test('all themes have wallpaper paths in assets/', () {
      final themes = MobileTheme.getChristmasThemes();
      for (final t in themes) {
        expect(t.wallpaperPath, startsWith('assets/images/wallpapers/'));
      }
    });
  });

  group('AudioHelper', () {
    test('requiredAudioFiles matches ringtone paths', () {
      final ringtones = Ringtone.getChristmasRingtones();
      final ringtonePaths = ringtones.map((r) => r.audioPath).toSet();
      final helperPaths = AudioHelper.requiredAudioFiles.toSet();

      expect(helperPaths, equals(ringtonePaths));
    });

    test('isValidAudioFile returns true for valid paths', () {
      expect(
        AudioHelper.isValidAudioFile('assets/audio/jingle_bells.mp3'),
        isTrue,
      );
    });

    test('isValidAudioFile returns false for unknown files', () {
      expect(AudioHelper.isValidAudioFile('assets/audio/unknown.mp3'), isFalse);
    });

    test('isValidAudioFile returns false for non-mp3', () {
      expect(
        AudioHelper.isValidAudioFile('assets/audio/jingle_bells.wav'),
        isFalse,
      );
    });
  });
}
