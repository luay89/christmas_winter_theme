class Ringtone {
  final String id;
  final String title;
  final String category;
  final String audioPath;
  final String description;

  Ringtone({
    required this.id,
    required this.title,
    required this.category,
    required this.audioPath,
    required this.description,
  });

  static List<Ringtone> getChristmasRingtones() {
    return [
      Ringtone(
        id: '1',
        title: 'Jingle Bells',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/jingle_bells.mp3',
        description: 'نغمة كلاسيكية لعيد الميلاد',
      ),
      Ringtone(
        id: '2',
        title: 'Silent Night',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/silent_night.mp3',
        description: 'ليلة هادئة مقدسة',
      ),
      Ringtone(
        id: '3',
        title: 'Deck the Halls',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/deck_the_halls.mp3',
        description: 'زينوا القاعات',
      ),
      Ringtone(
        id: '4',
        title: 'We Wish You a Merry Christmas',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/merry_christmas.mp3',
        description: 'نتمنى لك عيد ميلاد مجيد',
      ),
      Ringtone(
        id: '5',
        title: 'Santa Claus is Coming',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/santa_claus.mp3',
        description: 'سانتا كلوز قادم',
      ),
      Ringtone(
        id: '6',
        title: 'Frosty the Snowman',
        category: 'الشتاء',
        audioPath: 'assets/audio/frosty_snowman.mp3',
        description: 'فراستي رجل الثلج',
      ),
      Ringtone(
        id: '7',
        title: 'Let it Snow',
        category: 'الشتاء',
        audioPath: 'assets/audio/let_it_snow.mp3',
        description: 'دع الثلج يتساقط',
      ),
      Ringtone(
        id: '8',
        title: 'Winter Wonderland',
        category: 'الشتاء',
        audioPath: 'assets/audio/winter_wonderland.mp3',
        description: 'أرض الشتاء العجيبة',
      ),
      Ringtone(
        id: '9',
        title: 'Christmas Bells',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/christmas_bells.mp3',
        description: 'أجراس عيد الميلاد',
      ),
      Ringtone(
        id: '10',
        title: 'Joy to the World',
        category: 'عيد الميلاد',
        audioPath: 'assets/audio/joy_to_world.mp3',
        description: 'الفرح للعالم',
      ),
      Ringtone(
        id: '11',
        title: 'Snowflake',
        category: 'الشتاء',
        audioPath: 'assets/audio/snowflake.mp3',
        description: 'نقطة الثلج',
      ),
      Ringtone(
        id: '12',
        title: 'New Year Celebration',
        category: 'رأس السنة',
        audioPath: 'assets/audio/new_year.mp3',
        description: 'احتفال رأس السنة',
      ),
    ];
  }
}



