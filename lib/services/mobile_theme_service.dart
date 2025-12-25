import 'package:flutter/services.dart';

class MobileThemeService {
  static const MethodChannel _channel = MethodChannel(
    'com.christmastheme.theme_channel',
  );

  /// تعيين نغمة رنين
  static Future<bool> setRingtone(String audioPath) async {
    try {
      final result = await _channel.invokeMethod<bool>('setRingtone', {
        'audioPath': audioPath,
      });
      return result ?? false;
    } catch (e) {
      print('خطأ في تعيين نغمة الرنين: $e');
      return false;
    }
  }

  /// تعيين نغمة الإشعارات
  static Future<bool> setNotificationSound(String audioPath) async {
    try {
      final result = await _channel.invokeMethod<bool>('setNotificationSound', {
        'audioPath': audioPath,
      });
      return result ?? false;
    } catch (e) {
      print('خطأ في تعيين نغمة الإشعارات: $e');
      return false;
    }
  }

  /// فتح إعدادات النغمات
  static Future<void> openRingtoneSettings() async {
    try {
      await _channel.invokeMethod('openRingtoneSettings');
    } catch (e) {
      print('خطأ في فتح إعدادات النغمات: $e');
    }
  }

  /// طلب السماح لتعديل إعدادات النظام (WRITE_SETTINGS) على Android
  static Future<void> requestWriteSettings() async {
    try {
      await _channel.invokeMethod('requestWriteSettings');
    } catch (e) {
      print('خطأ في طلب WRITE_SETTINGS: $e');
    }
  }
}
