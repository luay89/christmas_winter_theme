import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/mobile_theme.dart';
import '../models/ringtone.dart';
import '../services/mobile_theme_service.dart';
import '../services/ringtone_config_service.dart';
// audio_service not needed here
import '../theme/app_themes.dart';
import '../services/theme_service.dart';

class MobileThemesPage extends StatefulWidget {
  final void Function(ThemeStyle)? onThemeChanged;

  const MobileThemesPage({super.key, this.onThemeChanged});

  @override
  State<MobileThemesPage> createState() => _MobileThemesPageState();
}

class _MobileThemesPageState extends State<MobileThemesPage> {
  List<MobileTheme> _themes = [];
  MobileTheme? _selectedTheme;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _themes = MobileTheme.getChristmasThemes();
  }

  Future<void> _applyTheme(MobileTheme theme) async {
    setState(() {
      _isApplying = true;
      _selectedTheme = theme;
    });

    try {
      // تطبيق نغمة الرنين الأولى من قائمة النغمات
      if (theme.ringtoneIds.isNotEmpty) {
        final ringtones = Ringtone.getChristmasRingtones();
        final ringtone = ringtones.firstWhere(
          (r) => theme.ringtoneIds.contains(r.id),
          orElse: () => ringtones.first,
        );

        // تحقق مما إذا كان هناك مسار مخصص للنغمة (رابط تحميل أو ملف محلي)
        final override = await RingtoneConfigService.getCustomPath(ringtone.id);
        final pathToSet = override ?? ringtone.audioPath;

        final success = await MobileThemeService.setRingtone(pathToSet);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ تم تعيين ${ringtone.title} كنغمة رنين'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }

      // هزة خفيفة عند التطبيق
      HapticFeedback.mediumImpact();

      // تطبيق الثيم فوراً في التطبيق
      try {
        final themeStyle = _mapMobileThemeToThemeStyle(theme);
        // حفظ الثيم
        await ThemeService.setSelectedTheme(themeStyle);
        // إبلاغ الوالد ليُطبق الثيم فوراً
        widget.onThemeChanged?.call(themeStyle);
      } catch (e) {
        print('خطأ في تطبيق الثيم محلياً: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✨ ${theme.name} - تم تطبيق الثيم!'),
            backgroundColor: theme.primaryColor,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isApplying = false;
      });
    }
  }

  ThemeStyle _mapMobileThemeToThemeStyle(MobileTheme theme) {
    switch (theme.id) {
      case 'classic_christmas':
        return ThemeStyle.classicChristmas;
      case 'winter_wonderland':
        return ThemeStyle.winterWonderland;
      case 'golden_elegance':
        return ThemeStyle.goldenElegance;
      case 'cozy_fireplace':
        return ThemeStyle.cozyWarmth;
      case 'midnight_star':
        return ThemeStyle.midnightSnow;
      case 'santa_workshop':
        return ThemeStyle.classicChristmas;
      default:
        return ThemeStyle.classicChristmas;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 ثيمات الموبايل'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // عنوان توضيحي
            Card(
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ثيمات مبهرة للموبايل',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'اختر ثيم لتعيين خلفية ونغمة رنين جميلة',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // قائمة الثيمات
            ..._themes.map((mobileTheme) {
              final isSelected = _selectedTheme?.id == mobileTheme.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: mobileTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Card(
                  elevation: isSelected ? 8 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? mobileTheme.primaryColor
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: mobileTheme.gradientColors,
                        ),
                      ),
                      child: Column(
                        children: [
                          // معاينة الثيم
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: mobileTheme.gradientColors,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // تأثير متوهج
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        center: Alignment.topRight,
                                        radius: 1.5,
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // محتوى الثيم
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        mobileTheme.iconEmoji,
                                        style: const TextStyle(fontSize: 64),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        mobileTheme.name,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // معلومات الثيم
                          Container(
                            color: theme.colorScheme.surface,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mobileTheme.description,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // الألوان
                                Row(
                                  children: [
                                    Text(
                                      'الألوان: ',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    ...mobileTheme.gradientColors.map((color) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 2,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // زر التطبيق
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _isApplying
                                        ? null
                                        : () => _applyTheme(mobileTheme),
                                    icon: _isApplying && isSelected
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.auto_awesome,
                                          ),
                                    label: Text(
                                      _isApplying && isSelected
                                          ? 'جارٍ التطبيق...'
                                          : isSelected
                                          ? 'تم التطبيق ✓'
                                          : 'تطبيق الثيم ✨',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mobileTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: isSelected ? 8 : 4,
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
              );
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
