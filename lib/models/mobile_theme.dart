import 'dart:ui';

class MobileTheme {
  final String id;
  final String name;
  final String description;
  final String wallpaperPath;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> ringtoneIds;
  final String iconEmoji;
  final List<Color> gradientColors;

  MobileTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.wallpaperPath,
    required this.primaryColor,
    required this.secondaryColor,
    required this.ringtoneIds,
    required this.iconEmoji,
    required this.gradientColors,
  });

  static List<MobileTheme> getChristmasThemes() {
    return [
      MobileTheme(
        id: 'classic_christmas',
        name: '🎄 عيد الميلاد الكلاسيكي',
        description: 'أحمر وأخضر مع شجرة عيد الميلاد المتوهجة',
        wallpaperPath: 'assets/images/wallpapers/classic_christmas.jpg',
        primaryColor: const Color(0xFFD32F2F), // أحمر
        secondaryColor: const Color(0xFF388E3C), // أخضر
        ringtoneIds: ['1', '2', '4', '9'], // Jingle Bells, Silent Night, etc.
        iconEmoji: '🎄',
        gradientColors: [
          const Color(0xFFD32F2F),
          const Color(0xFF388E3C),
          const Color(0xFF1B5E20),
        ],
      ),
      MobileTheme(
        id: 'winter_wonderland',
        name: '❄️ أرض الشتاء العجيبة',
        description: 'ثلج ناصع وسماء زرقاء صافية',
        wallpaperPath: 'assets/images/wallpapers/winter_wonderland.jpg',
        primaryColor: const Color(0xFF64B5F6), // أزرق فاتح
        secondaryColor: const Color(0xFFE1F5FE), // أزرق فاتح جداً
        ringtoneIds: ['6', '7', '8', '11'], // Frosty, Let it Snow, etc.
        iconEmoji: '❄️',
        gradientColors: [
          const Color(0xFF64B5F6),
          const Color(0xFF90CAF9),
          const Color(0xFFE1F5FE),
        ],
      ),
      MobileTheme(
        id: 'golden_elegance',
        name: '✨ الأناقة الذهبية',
        description: 'ذهبي فاخر وأنيق للاحتفال',
        wallpaperPath: 'assets/images/wallpapers/golden_elegance.jpg',
        primaryColor: const Color(0xFFFFD700), // ذهبي
        secondaryColor: const Color(0xFFFFF8DC), // كريمي
        ringtoneIds: ['2', '9', '10'], // Silent Night, Christmas Bells, etc.
        iconEmoji: '✨',
        gradientColors: [
          const Color(0xFFFFD700),
          const Color(0xFFFFE44D),
          const Color(0xFFFFF8DC),
        ],
      ),
      MobileTheme(
        id: 'cozy_fireplace',
        name: '🔥 الموقد الدافئ',
        description: 'دفء الموقد والأضواء الدافئة',
        wallpaperPath: 'assets/images/wallpapers/cozy_fireplace.jpg',
        primaryColor: const Color(0xFFFF6B35), // برتقالي دافئ
        secondaryColor: const Color(0xFFFFB88C), // برتقالي فاتح
        ringtoneIds: ['2', '4', '10'], // Silent Night, Merry Christmas, etc.
        iconEmoji: '🔥',
        gradientColors: [
          const Color(0xFFFF6B35),
          const Color(0xFFFF8C65),
          const Color(0xFFFFB88C),
        ],
      ),
      MobileTheme(
        id: 'midnight_star',
        name: '🌙 ليلة النجوم',
        description: 'سماء ليلية مظلمة مع نجوم متلألئة',
        wallpaperPath: 'assets/images/wallpapers/midnight_star.jpg',
        primaryColor: const Color(0xFF3D5A80), // أزرق داكن
        secondaryColor: const Color(0xFFE0E0E0), // رمادي فاتح
        ringtoneIds: ['2', '6', '8'], // Silent Night, Frosty, Winter Wonderland
        iconEmoji: '🌙',
        gradientColors: [
          const Color(0xFF1A237E),
          const Color(0xFF3D5A80),
          const Color(0xFF546E7A),
        ],
      ),
      MobileTheme(
        id: 'santa_workshop',
        name: '🎅 ورشة سانتا',
        description: 'أجواء سانتا كلوز والألعاب',
        wallpaperPath: 'assets/images/wallpapers/santa_workshop.jpg',
        primaryColor: const Color(0xFFD32F2F), // أحمر
        secondaryColor: const Color(0xFFFBC02D), // أصفر
        ringtoneIds: ['1', '5', '9'], // Jingle Bells, Santa Claus, etc.
        iconEmoji: '🎅',
        gradientColors: [
          const Color(0xFFD32F2F),
          const Color(0xFFFBC02D),
          const Color(0xFFFFE082),
        ],
      ),
    ];
  }
}



