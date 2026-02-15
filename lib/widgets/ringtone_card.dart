import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/ringtone.dart';
import '../services/audio_service.dart';
import '../services/mobile_theme_service.dart';
import '../services/download_service.dart';
import '../services/ringtone_config_service.dart';
import '../pages/ringtone_detail_page.dart';

class RingtoneCard extends StatefulWidget {
  final Ringtone ringtone;
  final VoidCallback? onPlay;

  const RingtoneCard({super.key, required this.ringtone, this.onPlay});

  @override
  State<RingtoneCard> createState() => _RingtoneCardState();
}

class _RingtoneCardState extends State<RingtoneCard> {
  String? _overridePath;

  /// Stream subscription for player state changes - must be cancelled in dispose()
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // الاستماع لتغييرات حالة التشغيل - with proper subscription management
    _playerStateSubscription = AudioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
    _positionSubscription = AudioService.positionStream.listen((pos) {
      if (mounted && AudioService.currentPlayingId == widget.ringtone.id) {
        setState(() => _position = pos);
      }
    });
    _durationSubscription = AudioService.durationStream.listen((dur) {
      if (mounted && AudioService.currentPlayingId == widget.ringtone.id) {
        setState(() => _duration = dur);
      }
    });
    _loadOverride();
  }

  @override
  void dispose() {
    // CRITICAL: Cancel subscriptions to prevent memory leak
    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _durationSubscription?.cancel();
    _durationSubscription = null;
    super.dispose();
  }

  Future<void> _loadOverride() async {
    final p = await RingtoneConfigService.getCustomPath(widget.ringtone.id);
    if (mounted) setState(() => _overridePath = p);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrentlyPlaying =
        AudioService.currentPlayingId == widget.ringtone.id &&
        AudioService.isPlaying;
    final isThisActive = AudioService.currentPlayingId == widget.ringtone.id;
    final progress = (isThisActive && _duration.inMilliseconds > 0)
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          try {
            final pathToPlay = _overridePath ?? widget.ringtone.audioPath;
            await AudioService.playRingtone(pathToPlay, widget.ringtone.id);
            if (widget.onPlay != null) widget.onPlay!();
            if (mounted) {
              setState(() {});
            }
          } catch (e) {
            // في حالة عدم وجود الملف الصوتي
            if (mounted && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الملف الصوتي غير موجود',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.ringtone.title}\nضع الملف في: assets/audio/${widget.ringtone.audioPath.replaceFirst("assets/audio/", "")}',
                      ),
                    ],
                  ),

                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        },
        onLongPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RingtoneDetailPage(ringtone: widget.ringtone),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // أيقونة النغمة
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.ringtone.category == 'عيد الميلاد'
                          ? Icons.card_giftcard
                          : widget.ringtone.category == 'الشتاء'
                          ? Icons.ac_unit
                          : Icons.celebration,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // معلومات النغمة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.ringtone.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.ringtone.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.ringtone.category,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // أزرار التحكم
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر التشغيل
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isCurrentlyPlaying
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                            color: isCurrentlyPlaying
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                          onPressed: () async {
                            try {
                              if (isCurrentlyPlaying) {
                                await AudioService.pause();
                              } else {
                                final pathToPlay =
                                    _overridePath ?? widget.ringtone.audioPath;
                                await AudioService.playRingtone(
                                  pathToPlay,
                                  widget.ringtone.id,
                                );
                                if (widget.onPlay != null) widget.onPlay!();
                              }
                              if (mounted) {
                                setState(() {});
                              }
                            } catch (e) {
                              // في حالة عدم وجود الملف الصوتي
                              if (mounted && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'الملف الصوتي غير موجود',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${widget.ringtone.title}\nضع الملف في: assets/audio/${widget.ringtone.audioPath.replaceFirst("assets/audio/", "")}',
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // زر تعيين كنغمة رنين
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.phone_android,
                            color: theme.colorScheme.secondary,
                            size: 22,
                          ),
                          onPressed: () async {
                            try {
                              final pathToSet =
                                  _overridePath ?? widget.ringtone.audioPath;
                              final success =
                                  await MobileThemeService.setRingtone(
                                    pathToSet,
                                  );
                              if (mounted && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? '✅ ${widget.ringtone.title} - اختر من القائمة'
                                          : '⚠️ الملف غير موجود. أضف الملف أولاً',
                                    ),
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.orange,
                                    duration: const Duration(seconds: 3),
                                    action: success
                                        ? SnackBarAction(
                                            label: 'إعدادات',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              MobileThemeService.openRingtoneSettings();
                                            },
                                          )
                                        : null,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('خطأ: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          tooltip: 'تعيين كنغمة رنين',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // زر التحميل والتعيين من الانترنت (إن وُجد رابط تحميل)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.download_rounded),
                          onPressed: () async {
                            // تحقق من وجود رابط تحميل داخل audioPath (نعتبره رابط إن كان يبدأ بـ http)
                            final path = widget.ringtone.audioPath;
                            if (!path.startsWith('http')) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'لا يوجد رابط تحميل مباشر لهذه النغمة',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                              return;
                            }

                            // تنزيل الملف
                            try {
                              final fileName = path.split('/').last;
                              // استدعي الخدمة الجديدة
                              final localPath =
                                  await DownloadService.downloadToLocal(
                                    path,
                                    fileName,
                                  );
                              if (localPath == null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('فشل في التحميل'),
                                    ),
                                  );
                                }
                                return;
                              }

                              // اطلب صلاحية تعديل الإعدادات قبل التعيين
                              await MobileThemeService.requestWriteSettings();

                              final success =
                                  await MobileThemeService.setRingtone(
                                    localPath,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? '✅ تم تنزيل وتعيين ${widget.ringtone.title} كنغمة رنين'
                                          : '⚠️ تم التنزيل لكن لم يتم التعيين تلقائياً',
                                    ),
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.orange,
                                    action: success
                                        ? null
                                        : SnackBarAction(
                                            label: 'إعدادات',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              MobileThemeService.openRingtoneSettings();
                                            },
                                          ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'خطأ في التحميل أو التعيين: $e',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          tooltip: 'تحميل وتعيين',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Inline progress bar
            if (isThisActive)
              LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
