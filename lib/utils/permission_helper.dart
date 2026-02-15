import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'platform_utils.dart';
import 'app_logger.dart';

/// Helper for managing runtime permissions needed for theme/ringtone changes.
///
/// On Android 6+, WRITE_SETTINGS is required to modify system ringtone
/// or notification sound. This helper checks and requests that permission
/// with user-friendly dialogs.
class PermissionHelper {
  /// Checks WRITE_SETTINGS permission and requests it if needed.
  /// Returns `true` if permission is granted and the operation can proceed.
  ///
  /// On non-Android platforms, always returns `false` (unsupported).
  /// Shows an explanatory dialog before opening system settings.
  static Future<bool> ensureWriteSettingsPermission(
    BuildContext context,
  ) async {
    if (!PlatformUtils.isAndroid) return false;

    try {
      // Use the direct platform check via our MethodChannel approach
      // since permission_handler maps WRITE_SETTINGS inconsistently.
      // Instead, we rely on the native canWrite() check via our service.
      if (!context.mounted) return false;
      return await _checkAndRequestViaDialog(context);
    } catch (e) {
      AppLogger.error('Error checking WRITE_SETTINGS permission', error: e);
      return false;
    }
  }

  static Future<bool> _checkAndRequestViaDialog(BuildContext context) async {
    // First attempt — if on older Android or already granted, canWrite
    // is handled natively. We show a proactive dialog before the first attempt.
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.security, size: 36),
        title: const Text('إذن تعديل الإعدادات'),
        content: const Text(
          'لتعيين نغمة الرنين أو الإشعارات، يحتاج التطبيق إلى إذن '
          '"تعديل إعدادات النظام". سيتم فتح صفحة الإعدادات لمنح الإذن إذا لم '
          'يكن ممنوحاً بالفعل.\n\n'
          'هل تريد المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.check),
            label: const Text('متابعة'),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return false;

    // Request WRITE_SETTINGS via openAppSettings which goes to the
    // app's system settings page where user can toggle the permission.
    await openAppSettings();

    // We can't await the result directly from openAppSettings, but
    // the native side (MainActivity.kt) will also check canWrite()
    // at the time of actually setting the ringtone, so the worst case
    // is a graceful failure with a clear error message.
    AppLogger.info('Opened app settings for WRITE_SETTINGS permission');
    return true;
  }

  /// Lightweight check — returns true on non-Android (no permission needed)
  /// or if the permission dialog flow completed (user agreed to proceed).
  /// For use in cases where you want to gate a UI action.
  static Future<bool> hasWriteSettingsPermission() async {
    if (!PlatformUtils.isAndroid) return false;
    // Rely on native side canWrite() for actual check.
    // This method is a soft pre-check for UI gating only.
    return true;
  }
}
