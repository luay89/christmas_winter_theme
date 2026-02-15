import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_themes.dart';
import 'services/theme_service.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/mobile_themes_page.dart';
import 'services/service_providers.dart';
import 'utils/app_logger.dart';

void main() async {
  // Global error handling zone
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Setup Flutter framework error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.error(
          'Flutter framework error: ${details.exceptionAsString()}',
          error: details.exception,
          stackTrace: details.stack,
        );
        // In debug mode, also print to console for visibility
        if (kDebugMode) {
          FlutterError.dumpErrorToConsole(details);
        }
      };

      // Handle errors in async code that are not caught by Flutter
      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.error(
          'Platform dispatcher error',
          error: error,
          stackTrace: stack,
        );
        return true; // Prevents the error from propagating
      };

      // تعيين اتجاه النص من اليمين لليسار
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      AppLogger.info('Application starting...');
      runApp(const ServiceProviders(child: ChristmasThemeApp()));
    },
    (error, stack) {
      // Catch any errors that escape the zone
      AppLogger.error('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}

class ChristmasThemeApp extends StatefulWidget {
  const ChristmasThemeApp({super.key});

  @override
  State<ChristmasThemeApp> createState() => _ChristmasThemeAppState();
}

class _ChristmasThemeAppState extends State<ChristmasThemeApp> {
  ThemeStyle _currentTheme = ThemeStyle.classicChristmas;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final theme = await ThemeService.getSelectedTheme();
      if (mounted) {
        setState(() => _currentTheme = theme);
      }
    } catch (e, stack) {
      AppLogger.error('Error loading theme', error: e, stackTrace: stack);
      // نستخدم الثيم الافتراضي في حالة الخطأ
    }
  }

  @override
  void dispose() {
    // AudioService lifecycle managed by Provider
    super.dispose();
  }

  void _changeTheme(ThemeStyle theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ثيم عيد الميلاد والشتاء',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(_currentTheme),
      home: MainScreen(onThemeChanged: _changeTheme),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(ThemeStyle) onThemeChanged;

  const MainScreen({super.key, required this.onThemeChanged});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePage(),
          MobileThemesPage(onThemeChanged: widget.onThemeChanged),
          SettingsPage(onThemeChanged: widget.onThemeChanged),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.music_note),
            selectedIcon: Icon(Icons.music_note),
            label: 'النغمات',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'ثيمات الموبايل',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}
