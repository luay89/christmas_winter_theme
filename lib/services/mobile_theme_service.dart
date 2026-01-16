import 'package:flutter/services.dart';
import '../utils/app_logger.dart';
import '../utils/platform_utils.dart';

/// Result class for platform operations
class PlatformOperationResult {
  final bool success;
  final String? errorMessage;

  const PlatformOperationResult({
    required this.success,
    this.errorMessage,
  });

  factory PlatformOperationResult.successful() =>
      const PlatformOperationResult(success: true);

  factory PlatformOperationResult.failed(String message) =>
      PlatformOperationResult(success: false, errorMessage: message);

  factory PlatformOperationResult.unsupportedPlatform() =>
      PlatformOperationResult(
        success: false,
        errorMessage:
            'هذه الميزة غير مدعومة على ${PlatformUtils.platformName}',
      );
}

/// Service for mobile theme operations (ringtones, wallpapers).
/// 
/// Platform support: Android only.
/// On unsupported platforms, operations fail gracefully with appropriate messages.
/// 
/// This service is designed to be injectable (not static singleton).
class MobileThemeService {
  static const String _channelName = 'com.christmastheme.theme_channel';
  
  final MethodChannel _channel;

  /// Creates a new instance of MobileThemeService.
  /// 
  /// For production use, use the default constructor.
  /// For testing, inject a mock MethodChannel.
  MobileThemeService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel(_channelName);

  /// Default singleton instance for backward compatibility during migration.
  /// TODO: Remove after full dependency injection implementation.
  static final MobileThemeService _instance = MobileThemeService();
  static MobileThemeService get instance => _instance;

  /// تعيين نغمة رنين
  /// Returns [PlatformOperationResult] indicating success or failure with message.
  Future<PlatformOperationResult> setRingtoneWithResult(String audioPath) async {
    // Platform guard
    if (!PlatformUtils.supportsMobileThemeFeatures) {
      AppLogger.warning(
        'setRingtone called on unsupported platform: ${PlatformUtils.platformName}',
      );
      return PlatformOperationResult.unsupportedPlatform();
    }

    // Input validation
    if (audioPath.isEmpty) {
      return PlatformOperationResult.failed('مسار الملف الصوتي فارغ');
    }

    try {
      final result = await _channel.invokeMethod<bool>('setRingtone', {
        'audioPath': audioPath,
      });
      
      if (result == true) {
        AppLogger.info('Ringtone set successfully: $audioPath');
        return PlatformOperationResult.successful();
      } else {
        return PlatformOperationResult.failed('فشل في تعيين نغمة الرنين');
      }
    } on PlatformException catch (e) {
      AppLogger.error('Platform error setting ringtone', error: e);
      return PlatformOperationResult.failed('خطأ في النظام: ${e.message}');
    } on MissingPluginException catch (e) {
      AppLogger.error('Missing plugin for ringtone', error: e);
      return PlatformOperationResult.failed('الميزة غير متاحة على هذا الجهاز');
    } catch (e, stack) {
      AppLogger.error('Unexpected error setting ringtone', error: e, stackTrace: stack);
      return PlatformOperationResult.failed('خطأ غير متوقع: $e');
    }
  }

  /// تعيين نغمة الإشعارات
  Future<PlatformOperationResult> setNotificationSoundWithResult(String audioPath) async {
    // Platform guard
    if (!PlatformUtils.supportsMobileThemeFeatures) {
      AppLogger.warning(
        'setNotificationSound called on unsupported platform: ${PlatformUtils.platformName}',
      );
      return PlatformOperationResult.unsupportedPlatform();
    }

    // Input validation
    if (audioPath.isEmpty) {
      return PlatformOperationResult.failed('مسار الملف الصوتي فارغ');
    }

    try {
      final result = await _channel.invokeMethod<bool>('setNotificationSound', {
        'audioPath': audioPath,
      });
      
      if (result == true) {
        AppLogger.info('Notification sound set successfully: $audioPath');
        return PlatformOperationResult.successful();
      } else {
        return PlatformOperationResult.failed('فشل في تعيين نغمة الإشعارات');
      }
    } on PlatformException catch (e) {
      AppLogger.error('Platform error setting notification sound', error: e);
      return PlatformOperationResult.failed('خطأ في النظام: ${e.message}');
    } on MissingPluginException catch (e) {
      AppLogger.error('Missing plugin for notification sound', error: e);
      return PlatformOperationResult.failed('الميزة غير متاحة على هذا الجهاز');
    } catch (e, stack) {
      AppLogger.error('Unexpected error setting notification sound', error: e, stackTrace: stack);
      return PlatformOperationResult.failed('خطأ غير متوقع: $e');
    }
  }

  /// فتح إعدادات النغمات
  Future<PlatformOperationResult> openRingtoneSettingsWithResult() async {
    // Platform guard
    if (!PlatformUtils.supportsMobileThemeFeatures) {
      AppLogger.warning(
        'openRingtoneSettings called on unsupported platform: ${PlatformUtils.platformName}',
      );
      return PlatformOperationResult.unsupportedPlatform();
    }

    try {
      await _channel.invokeMethod('openRingtoneSettings');
      AppLogger.info('Opened ringtone settings');
      return PlatformOperationResult.successful();
    } on PlatformException catch (e) {
      AppLogger.error('Platform error opening ringtone settings', error: e);
      return PlatformOperationResult.failed('خطأ في فتح الإعدادات: ${e.message}');
    } on MissingPluginException catch (e) {
      AppLogger.error('Missing plugin for ringtone settings', error: e);
      return PlatformOperationResult.failed('الميزة غير متاحة على هذا الجهاز');
    } catch (e, stack) {
      AppLogger.error('Unexpected error opening ringtone settings', error: e, stackTrace: stack);
      return PlatformOperationResult.failed('خطأ غير متوقع: $e');
    }
  }

  /// طلب السماح لتعديل إعدادات النظام (WRITE_SETTINGS) على Android
  Future<PlatformOperationResult> requestWriteSettingsWithResult() async {
    // Platform guard
    if (!PlatformUtils.supportsMobileThemeFeatures) {
      AppLogger.warning(
        'requestWriteSettings called on unsupported platform: ${PlatformUtils.platformName}',
      );
      return PlatformOperationResult.unsupportedPlatform();
    }

    try {
      await _channel.invokeMethod('requestWriteSettings');
      AppLogger.info('Requested WRITE_SETTINGS permission');
      return PlatformOperationResult.successful();
    } on PlatformException catch (e) {
      AppLogger.error('Platform error requesting WRITE_SETTINGS', error: e);
      return PlatformOperationResult.failed('خطأ في طلب الإذن: ${e.message}');
    } on MissingPluginException catch (e) {
      AppLogger.error('Missing plugin for WRITE_SETTINGS', error: e);
      return PlatformOperationResult.failed('الميزة غير متاحة على هذا الجهاز');
    } catch (e, stack) {
      AppLogger.error('Unexpected error requesting WRITE_SETTINGS', error: e, stackTrace: stack);
      return PlatformOperationResult.failed('خطأ غير متوقع: $e');
    }
  }

  /// Check if the current platform supports mobile theme features
  bool get isPlatformSupported => PlatformUtils.supportsMobileThemeFeatures;

  // ============================================
  // LEGACY STATIC METHODS (for backward compatibility)
  // These maintain the original API while using the new implementation
  // ============================================

  /// تعيين نغمة رنين (Legacy static method)
  static Future<bool> setRingtone(String audioPath) async {
    final result = await _instance.setRingtoneWithResult(audioPath);
    return result.success;
  }

  /// تعيين نغمة الإشعارات (Legacy static method)
  static Future<bool> setNotificationSound(String audioPath) async {
    final result = await _instance.setNotificationSoundWithResult(audioPath);
    return result.success;
  }

  /// فتح إعدادات النغمات (Legacy static method)
  static Future<void> openRingtoneSettings() async {
    await _instance.openRingtoneSettingsWithResult();
  }

  /// طلب السماح لتعديل إعدادات النظام (Legacy static method)
  static Future<void> requestWriteSettings() async {
    await _instance.requestWriteSettingsWithResult();
  }
}
