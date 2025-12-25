package com.christmastheme.christmas_winter_theme

import android.content.ContentValues
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.christmastheme.theme_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setRingtone" -> {
                    val audioPath = call.argument<String>("audioPath")
                    if (audioPath != null) {
                        val success = setRingtone(audioPath)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Audio path is null", null)
                    }
                }
                "setNotificationSound" -> {
                    val audioPath = call.argument<String>("audioPath")
                    if (audioPath != null) {
                        val success = setNotificationSound(audioPath)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Audio path is null", null)
                    }
                }
                "openRingtoneSettings" -> {
                    openRingtoneSettings()
                    result.success(true)
                }
                "requestWriteSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
                        intent.data = Uri.parse("package:" + applicationContext.packageName)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        e.printStackTrace()
                        result.error("ERROR", "failed to open settings", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun setRingtone(audioPath: String): Boolean {
        return try {
            // إذا كان المسار هو من الأصول داخل الـ APK (assets)، انسخ الملف إلى MediaStore وحاول تعيينه
            val uri = copyAssetToRingtonesAndGetUri(audioPath, isRingtone = true)
            if (uri != null) {
                RingtoneManager.setActualDefaultRingtoneUri(this, RingtoneManager.TYPE_RINGTONE, uri)
                return true
            }

            // فشل النسخ - افتح مُختار النغمات كحل احتياطي
            val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_RINGTONE)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, true)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "اختر نغمة الرنين")
            startActivity(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            // في حالة الفشل، افتح إعدادات الصوت العامة
            try {
                openRingtoneSettings()
                true
            } catch (e2: Exception) {
                e2.printStackTrace()
                false
            }
        }
    }

    private fun setNotificationSound(audioPath: String): Boolean {
        return try {
            val uri = copyAssetToRingtonesAndGetUri(audioPath, isRingtone = false, isNotification = true)
            if (uri != null) {
                RingtoneManager.setActualDefaultRingtoneUri(this, RingtoneManager.TYPE_NOTIFICATION, uri)
                return true
            }

            val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_NOTIFICATION)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, true)
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "اختر نغمة الإشعارات")
            startActivity(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            try {
                openRingtoneSettings()
                true
            } catch (e2: Exception) {
                e2.printStackTrace()
                false
            }
        }
    }

    private fun copyAssetToRingtonesAndGetUri(audioPath: String, isRingtone: Boolean = true, isNotification: Boolean = false): Uri? {
        return try {
            val resolver = contentResolver

            val fileName = audioPath.substringAfterLast('/')
            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, "audio/mpeg")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_RINGTONES)
                }
                put(MediaStore.Audio.AudioColumns.IS_RINGTONE, if (isRingtone) 1 else 0)
                put(MediaStore.Audio.AudioColumns.IS_NOTIFICATION, if (isNotification) 1 else 0)
                put(MediaStore.Audio.AudioColumns.IS_ALARM, 0)
                put(MediaStore.Audio.AudioColumns.IS_MUSIC, 0)
            }

            val collection = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            } else {
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            }

            val uri = resolver.insert(collection, values) ?: return null

            resolver.openOutputStream(uri).use { outStream ->
                if (outStream == null) return null

                // إذا كان المسار ملفًا محليًا مطلقًا أو يبدأ بـ file://
                if (audioPath.startsWith("/") || audioPath.startsWith("file://")) {
                    val filePath = if (audioPath.startsWith("file://")) Uri.parse(audioPath).path else audioPath
                    val srcFile = File(filePath)
                    FileInputStream(srcFile).use { fis ->
                        fis.copyTo(outStream)
                    }
                } else {
                    // افتراض أنه مسار داخل أصول التطبيق
                    val assetPathToOpen = if (audioPath.startsWith("flutter_assets")) audioPath else "flutter_assets/$audioPath"
                    assets.open(assetPathToOpen).use { input ->
                        input.copyTo(outStream)
                    }
                }
            }

            val updatedValues = ContentValues().apply {
                put(MediaStore.Audio.AudioColumns.IS_RINGTONE, if (isRingtone) 1 else 0)
                put(MediaStore.Audio.AudioColumns.IS_NOTIFICATION, if (isNotification) 1 else 0)
            }
            resolver.update(uri, updatedValues, null, null)

            uri
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun openRingtoneSettings() {
        try {
            val intent = Intent(Settings.ACTION_SOUND_SETTINGS)
            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
