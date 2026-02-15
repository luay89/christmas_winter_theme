import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_winter_theme/services/mobile_theme_service.dart';

void main() {
  group('MobileThemeService', () {
    test('PlatformOperationResult.successful() returns success', () {
      final result = PlatformOperationResult.successful();
      expect(result.success, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('PlatformOperationResult.failed() returns failure with message', () {
      final result = PlatformOperationResult.failed('test error');
      expect(result.success, isFalse);
      expect(result.errorMessage, 'test error');
    });

    test('PlatformOperationResult.unsupportedPlatform() returns failure', () {
      final result = PlatformOperationResult.unsupportedPlatform();
      expect(result.success, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('setRingtoneWithResult rejects empty path', () async {
      // Create a service with a mock channel that should not be called
      final channel = MethodChannel('test_channel');
      final service = MobileThemeService(channel: channel);

      // On non-Android platform, should fail gracefully
      final result = await service.setRingtoneWithResult('');
      expect(result.success, isFalse);
    });

    test('setNotificationSoundWithResult rejects empty path', () async {
      final channel = MethodChannel('test_channel');
      final service = MobileThemeService(channel: channel);

      final result = await service.setNotificationSoundWithResult('');
      expect(result.success, isFalse);
    });
  });
}
