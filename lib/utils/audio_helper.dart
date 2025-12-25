// ملف مساعد للتعامل مع ملفات الصوت
// يحتوي على معلومات عن ملفات الصوت المطلوبة

class AudioHelper {
  /// قائمة بجميع ملفات الصوت المطلوبة
  static List<String> get requiredAudioFiles => [
        'assets/audio/jingle_bells.mp3',
        'assets/audio/silent_night.mp3',
        'assets/audio/deck_the_halls.mp3',
        'assets/audio/merry_christmas.mp3',
        'assets/audio/santa_claus.mp3',
        'assets/audio/frosty_snowman.mp3',
        'assets/audio/let_it_snow.mp3',
        'assets/audio/winter_wonderland.mp3',
        'assets/audio/christmas_bells.mp3',
        'assets/audio/joy_to_world.mp3',
        'assets/audio/snowflake.mp3',
        'assets/audio/new_year.mp3',
      ];

  /// رسالة توضح كيفية إضافة الملفات الصوتية
  static String get audioFilesInstruction => '''
ملاحظة: لإكمال التطبيق، يجب إضافة ملفات الصوت التالية:

${requiredAudioFiles.map((f) => f.replaceFirst('assets/audio/', '')).join('\n')}

يمكنك:
1. تحميل ملفات MP3 من مصادر مجانية مثل:
   - FreeMusicArchive
   - Freesound
   - YouTube Audio Library

2. وضع الملفات في المجلد: assets/audio/

3. التأكد من أن أسماء الملفات تطابق القائمة أعلاه

ملاحظة: تأكد من الحصول على التراخيص المناسبة لاستخدام الملفات الصوتية.
''';

  /// التحقق من وجود ملف صوتي (يمكن استخدامه في المستقبل)
  static bool isValidAudioFile(String path) {
    return requiredAudioFiles.contains(path) && path.endsWith('.mp3');
  }
}



