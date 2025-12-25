import 'package:flutter/material.dart';

enum ThemeStyle {
  classicChristmas,    // أحمر وأخضر كلاسيكي
  winterWonderland,    // أزرق فاتح وثلج
  goldenElegance,      // ذهبي وأنيق
  cozyWarmth,          // برتقالي دافئ
  midnightSnow,        // أزرق داكن وثلج
}

class AppThemes {
  static ThemeData getTheme(ThemeStyle style) {
    switch (style) {
      case ThemeStyle.classicChristmas:
        return _classicChristmasTheme;
      case ThemeStyle.winterWonderland:
        return _winterWonderlandTheme;
      case ThemeStyle.goldenElegance:
        return _goldenEleganceTheme;
      case ThemeStyle.cozyWarmth:
        return _cozyWarmthTheme;
      case ThemeStyle.midnightSnow:
        return _midnightSnowTheme;
    }
  }

  static String getThemeName(ThemeStyle style) {
    switch (style) {
      case ThemeStyle.classicChristmas:
        return 'عيد الميلاد الكلاسيكي';
      case ThemeStyle.winterWonderland:
        return 'أرض الشتاء العجيبة';
      case ThemeStyle.goldenElegance:
        return 'الأناقة الذهبية';
      case ThemeStyle.cozyWarmth:
        return 'الدفء المريح';
      case ThemeStyle.midnightSnow:
        return 'ثلج منتصف الليل';
    }
  }

  static ColorScheme getColorScheme(ThemeStyle style) {
    switch (style) {
      case ThemeStyle.classicChristmas:
        return ColorScheme.dark(
          primary: const Color(0xFFD32F2F), // أحمر
          secondary: const Color(0xFF388E3C), // أخضر
          surface: const Color(0xFF1B1B1B),
          surfaceContainerHighest: const Color(0xFF121212),
          error: const Color(0xFFCF6679),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          brightness: Brightness.dark,
        );
      case ThemeStyle.winterWonderland:
        return ColorScheme.dark(
          primary: const Color(0xFF64B5F6), // أزرق فاتح
          secondary: const Color(0xFFE1F5FE), // أزرق فاتح جداً
          surface: const Color(0xFF1E3A5F),
          surfaceContainerHighest: const Color(0xFF0D1B2A),
          error: const Color(0xFFEF5350),
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF0D1B2A),
          onSurface: Colors.white,
          brightness: Brightness.dark,
        );
      case ThemeStyle.goldenElegance:
        return ColorScheme.dark(
          primary: const Color(0xFFFFD700), // ذهبي
          secondary: const Color(0xFFFFF8DC), // كريمي
          surface: const Color(0xFF2C2416),
          surfaceContainerHighest: const Color(0xFF1A1611),
          error: const Color(0xFFE57373),
          onPrimary: const Color(0xFF1A1611),
          onSecondary: const Color(0xFF1A1611),
          onSurface: Colors.white,
          brightness: Brightness.dark,
        );
      case ThemeStyle.cozyWarmth:
        return ColorScheme.dark(
          primary: const Color(0xFFFF6B35), // برتقالي دافئ
          secondary: const Color(0xFFFFB88C), // برتقالي فاتح
          surface: const Color(0xFF2E1F17),
          surfaceContainerHighest: const Color(0xFF1A120B),
          error: const Color(0xFFE57373),
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF1A120B),
          onSurface: Colors.white,
          brightness: Brightness.dark,
        );
      case ThemeStyle.midnightSnow:
        return ColorScheme.dark(
          primary: const Color(0xFF3D5A80), // أزرق داكن
          secondary: const Color(0xFFE0E0E0), // رمادي فاتح
          surface: const Color(0xFF1A1F2E),
          surfaceContainerHighest: const Color(0xFF0F1419),
          error: const Color(0xFFEF5350),
          onPrimary: Colors.white,
          onSecondary: const Color(0xFF0F1419),
          onSurface: Colors.white,
          brightness: Brightness.dark,
        );
    }
  }

  static ThemeData get _classicChristmasTheme {
    final colorScheme = getColorScheme(ThemeStyle.classicChristmas);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get _winterWonderlandTheme {
    final colorScheme = getColorScheme(ThemeStyle.winterWonderland);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get _goldenEleganceTheme {
    final colorScheme = getColorScheme(ThemeStyle.goldenElegance);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get _cozyWarmthTheme {
    final colorScheme = getColorScheme(ThemeStyle.cozyWarmth);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get _midnightSnowTheme {
    final colorScheme = getColorScheme(ThemeStyle.midnightSnow);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
