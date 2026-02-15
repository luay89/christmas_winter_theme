import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/ringtone.dart';
import '../services/audio_service.dart';
import '../services/mobile_theme_service.dart';
import '../services/ringtone_config_service.dart';
import '../widgets/animated_snow.dart';
import '../utils/permission_helper.dart';

/// Full-screen ringtone detail page with player controls, progress bar,
/// and options to set as ringtone, notification, or alarm.
class RingtoneDetailPage extends StatefulWidget {
  final Ringtone ringtone;

  const RingtoneDetailPage({super.key, required this.ringtone});

  @override
  State<RingtoneDetailPage> createState() => _RingtoneDetailPageState();
}

class _RingtoneDetailPageState extends State<RingtoneDetailPage> {
  String? _overridePath;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _loadOverride();

    _stateSubscription = AudioService.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
    _positionSubscription = AudioService.positionStream.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _durationSubscription = AudioService.durationStream.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadOverride() async {
    final p = await RingtoneConfigService.getCustomPath(widget.ringtone.id);
    if (mounted) setState(() => _overridePath = p);
  }

  String get _effectivePath => _overridePath ?? widget.ringtone.audioPath;

  bool get _isThisPlaying =>
      AudioService.currentPlayingId == widget.ringtone.id &&
      AudioService.isPlaying;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _togglePlay() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_isThisPlaying) {
        await AudioService.pause();
      } else {
        await AudioService.playRingtone(_effectivePath, widget.ringtone.id);
      }
      if (mounted) setState(() {});
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('الملف الصوتي غير متاح: ${widget.ringtone.title}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _setAs(String type) async {
    // Check and request WRITE_SETTINGS permission
    if (!context.mounted) return;
    final ctx = context;
    final permitted = await PermissionHelper.ensureWriteSettingsPermission(ctx);
    if (!permitted) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('⚠️ يجب منح إذن تعديل الإعدادات أولاً'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final path = _effectivePath;
    PlatformOperationResult result;

    switch (type) {
      case 'ringtone':
        result = await MobileThemeService.instance.setRingtoneWithResult(path);
        break;
      case 'notification':
        result = await MobileThemeService.instance
            .setNotificationSoundWithResult(path);
        break;
      default:
        return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success
              ? '✅ تم تعيين ${widget.ringtone.title} كـ ${_typeLabel(type)}'
              : '⚠️ ${result.errorMessage ?? 'فشل في التعيين'}',
        ),
        backgroundColor: result.success ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 3),
        action: result.success
            ? SnackBarAction(
                label: 'إعدادات',
                textColor: Colors.white,
                onPressed: () => MobileThemeService.openRingtoneSettings(),
              )
            : null,
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'ringtone':
        return 'نغمة رنين';
      case 'notification':
        return 'نغمة إشعارات';
      default:
        return type;
    }
  }

  IconData _categoryIcon() {
    switch (widget.ringtone.category) {
      case 'عيد الميلاد':
        return Icons.card_giftcard;
      case 'الشتاء':
        return Icons.ac_unit;
      default:
        return Icons.celebration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with gradient + snow
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                      theme.colorScheme.surfaceContainerHighest,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: AnimatedSnow(snowflakeCount: 40, opacity: 0.25),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          // Category icon
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            child: Icon(
                              _categoryIcon(),
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.ringtone.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.ringtone.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Description
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.ringtone.description,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Player card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Progress slider
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                              activeTrackColor: theme.colorScheme.primary,
                              inactiveTrackColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                              thumbColor: theme.colorScheme.primary,
                            ),
                            child: Slider(
                              value: progress.clamp(0.0, 1.0),
                              onChanged: (_) {
                                // Seek not supported with AssetSource
                              },
                            ),
                          ),

                          // Time labels
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_position),
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  _formatDuration(_duration),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Play/pause button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Stop
                              IconButton(
                                onPressed: () async {
                                  await AudioService.stop();
                                  if (mounted) {
                                    setState(() {
                                      _position = Duration.zero;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.stop_rounded,
                                  size: 36,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Play/Pause
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: _togglePlay,
                                  icon: Icon(
                                    _isThisPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Set as... buttons
                  Text(
                    'تعيين كـ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SetAsButton(
                          icon: Icons.phone_android,
                          label: 'نغمة رنين',
                          color: theme.colorScheme.primary,
                          onPressed: () => _setAs('ringtone'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SetAsButton(
                          icon: Icons.notifications_active,
                          label: 'نغمة إشعارات',
                          color: theme.colorScheme.secondary,
                          onPressed: () => _setAs('notification'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetAsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SetAsButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
