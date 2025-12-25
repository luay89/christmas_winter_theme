import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static String? _currentPlayingId;

  static Future<void> playRingtone(String audioPath, String ringtoneId) async {
    try {
      if (_currentPlayingId == ringtoneId) {
        // إذا كانت النغمة نفسها تعزف، أوقفها
        await stop();
        return;
      }

      await stop();
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
        if (assetPath.startsWith('assets/'))
          assetPath = assetPath.replaceFirst('assets/', '');
        await _player.play(AssetSource(assetPath));
      }
    } catch (e) {
      // في حالة عدم وجود الملف، نقوم فقط بإيقاف التشغيل
      print('خطأ في تشغيل الملف الصوتي: $e');
      _currentPlayingId = null;
      rethrow;
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print('خطأ في إيقاف الصوت: $e');
    }
    _currentPlayingId = null;
  }

  static Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('خطأ في الإيقاف المؤقت: $e');
    }
  }

  static Future<void> resume() async {
    try {
      await _player.resume();
    } catch (e) {
      print('خطأ في الاستئناف: $e');
    }
  }

  static Stream<PlayerState> get playerStateStream =>
      _player.onPlayerStateChanged;
  static Stream<Duration> get positionStream => _player.onPositionChanged;
  static Stream<Duration> get durationStream => _player.onDurationChanged;

  static Future<Duration?> getDuration() => _player.getDuration();
  static Future<Duration?> getPosition() => _player.getCurrentPosition();

  static bool get isPlaying => _player.state == PlayerState.playing;
  static String? get currentPlayingId => _currentPlayingId;

  static void dispose() {
    _player.dispose();
  }
}
