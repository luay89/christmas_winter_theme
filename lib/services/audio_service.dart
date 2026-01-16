import 'package:audioplayers/audioplayers.dart';
import '../utils/app_logger.dart';

/// Service for audio playback operations.
/// 
/// This service is designed to be injectable (not static singleton).
/// Maintains backward compatibility with static methods during migration.
class AudioService {
  final AudioPlayer _player;
  String? _currentPlayingId;

  /// Creates a new instance of AudioService.
  /// 
  /// For production use, use the default constructor.
  /// For testing, inject a mock AudioPlayer.
  AudioService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  /// Default singleton instance for backward compatibility during migration.
  /// TODO: Remove after full dependency injection implementation.
  static final AudioService _instance = AudioService();
  static AudioService get instance => _instance;

  /// Plays a ringtone from the given path.
  /// 
  /// Supports:
  /// - Asset paths (e.g., 'assets/audio/ringtone.mp3')
  /// - File paths (e.g., '/storage/emulated/0/ringtone.mp3')
  /// - URLs (e.g., 'https://example.com/ringtone.mp3')
  Future<void> playRingtoneInstance(String audioPath, String ringtoneId) async {
    try {
      if (_currentPlayingId == ringtoneId) {
        // إذا كانت النغمة نفسها تعزف، أوقفها
        await stopInstance();
        return;
      }

      await stopInstance();
      _currentPlayingId = ringtoneId;
      
      // دعم عدة أنواع من المسارات: assets/, ملف محلي، أو رابط http
      if (audioPath.startsWith('http')) {
        await _player.play(UrlSource(audioPath));
      } else if (audioPath.startsWith('/') || audioPath.startsWith('file://')) {
        final filePath = audioPath.startsWith('file://')
            ? Uri.parse(audioPath).path
            : audioPath;
        await _player.play(DeviceFileSource(filePath));
      } else {
        // مسارات الأصول قد تبدأ ب 'assets/' - audioplayers تتوقع مسارًا نسبيًا داخل قسم assets
        var assetPath = audioPath;
        if (assetPath.startsWith('assets/')) {
          assetPath = assetPath.replaceFirst('assets/', '');
        }
        await _player.play(AssetSource(assetPath));
      }
      
      AppLogger.info('Playing audio: $audioPath (id: $ringtoneId)');
    } catch (e, stack) {
      AppLogger.error('Error playing audio file: $audioPath', error: e, stackTrace: stack);
      _currentPlayingId = null;
      rethrow;
    }
  }

  Future<void> stopInstance() async {
    try {
      await _player.stop();
      AppLogger.debug('Audio stopped');
    } catch (e, stack) {
      AppLogger.error('Error stopping audio', error: e, stackTrace: stack);
    }
    _currentPlayingId = null;
  }

  Future<void> pauseInstance() async {
    try {
      await _player.pause();
      AppLogger.debug('Audio paused');
    } catch (e, stack) {
      AppLogger.error('Error pausing audio', error: e, stackTrace: stack);
    }
  }

  Future<void> resumeInstance() async {
    try {
      await _player.resume();
      AppLogger.debug('Audio resumed');
    } catch (e, stack) {
      AppLogger.error('Error resuming audio', error: e, stackTrace: stack);
    }
  }

  Stream<PlayerState> get playerStateStreamInstance => _player.onPlayerStateChanged;
  Stream<Duration> get positionStreamInstance => _player.onPositionChanged;
  Stream<Duration> get durationStreamInstance => _player.onDurationChanged;

  Future<Duration?> getDurationInstance() => _player.getDuration();
  Future<Duration?> getPositionInstance() => _player.getCurrentPosition();

  bool get isPlayingInstance => _player.state == PlayerState.playing;
  String? get currentPlayingIdInstance => _currentPlayingId;

  void disposeInstance() {
    _player.dispose();
    AppLogger.debug('AudioService disposed');
  }

  // ============================================
  // LEGACY STATIC METHODS (for backward compatibility)
  // These maintain the original API while using the new implementation
  // ============================================

  static Future<void> playRingtone(String audioPath, String ringtoneId) =>
      _instance.playRingtoneInstance(audioPath, ringtoneId);

  static Future<void> stop() => _instance.stopInstance();

  static Future<void> pause() => _instance.pauseInstance();

  static Future<void> resume() => _instance.resumeInstance();

  static Stream<PlayerState> get playerStateStream =>
      _instance.playerStateStreamInstance;
  
  static Stream<Duration> get positionStream =>
      _instance.positionStreamInstance;
  
  static Stream<Duration> get durationStream =>
      _instance.durationStreamInstance;

  static Future<Duration?> getDuration() => _instance.getDurationInstance();
  
  static Future<Duration?> getPosition() => _instance.getPositionInstance();

  static bool get isPlaying => _instance.isPlayingInstance;
  
  static String? get currentPlayingId => _instance.currentPlayingIdInstance;

  static void dispose() => _instance.disposeInstance();
}
