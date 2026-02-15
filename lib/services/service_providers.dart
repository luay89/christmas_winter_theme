import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';
import '../services/download_service.dart';
import '../services/mobile_theme_service.dart';
import '../services/ringtone_config_service.dart';
import '../services/theme_service.dart';

/// Wraps the app with all service providers for dependency injection.
///
/// All services are created once and available via [Provider.of] or
/// [context.read] / [context.watch] throughout the widget tree.
class ServiceProviders extends StatelessWidget {
  final Widget child;

  const ServiceProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioService>(
          create: (_) => AudioService(),
          dispose: (_, service) => service.disposeInstance(),
        ),
        Provider<ThemeService>(create: (_) => ThemeService()),
        Provider<MobileThemeService>(create: (_) => MobileThemeService()),
        Provider<DownloadService>(
          create: (_) => DownloadService(),
          dispose: (_, service) => service.disposeInstance(),
        ),
        Provider<RingtoneConfigService>(create: (_) => RingtoneConfigService()),
      ],
      child: child,
    );
  }
}
