import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import '../services/theme_service.dart';
import '../services/mobile_theme_service.dart';

class SettingsPage extends StatelessWidget {
  final Function(ThemeStyle) onThemeChanged;

  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات'), centerTitle: true),
      body: FutureBuilder<ThemeStyle>(
        future: ThemeService.getSelectedTheme(),
        builder: (context, snapshot) {
          final currentTheme = snapshot.data ?? ThemeStyle.classicChristmas;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // عنوان قسم الثيمات
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'اختر الثيم',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // قائمة الثيمات
              ...ThemeStyle.values.map((themeStyle) {
                final isSelected = themeStyle == currentTheme;
                final colorScheme = AppThemes.getColorScheme(themeStyle);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isSelected
                        ? BorderSide(color: colorScheme.primary, width: 3)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    onTap: () async {
                      // حفظ الثيم
                      await ThemeService.setSelectedTheme(themeStyle);
                      // تطبيق الثيم فوراً
                      onThemeChanged(themeStyle);
                      // إظهار رسالة تأكيد
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم تطبيق ثيم: ${AppThemes.getThemeName(themeStyle)}',
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  colorScheme.primary.withOpacity(0.1),
                                  colorScheme.secondary.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          // معاينة الألوان
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // اسم الثيم
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppThemes.getThemeName(themeStyle),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getThemeDescription(themeStyle),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // علامة الاختيار
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              // صلاحية تعديل إعدادات النظام (لتمكين تعيين النغمات تلقائيًا)
              Card(
                child: ListTile(
                  title: const Text('صلاحية تعديل إعدادات النظام'),
                  subtitle: const Text(
                    'مطلوبة لبعض أجهزة Android لتعيين النغمات تلقائيًا. اضغط لفتح الإعدادات.',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      // إظهار شرح بسيط ثم طلب فتح الإعدادات
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('السماح بتعديل الإعدادات'),
                          content: const Text(
                            'بعض أجهزة Android تتطلب أن تسمح للتطبيق بتعديل إعدادات النظام حتى يتمكن من تعيين نغمات الرنين تلقائيًا. سيتم فتح صفحة الإعدادات حيث يمكنك تفعيل الإذن.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('إلغاء'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('فتح الإعدادات'),
                            ),
                          ],
                        ),
                      );

                      if (ok == true) {
                        await MobileThemeService.requestWriteSettings();
                      }
                    },
                    child: const Text('اطلب الإذن'),
                  ),
                ),
              ),
              // معلومات التطبيق
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'عن التطبيق',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ثيم عيد الميلاد والشتاء\nتطبيق يوفر نغمات جميلة لعيد الميلاد والشتاء مع ثيمات متنوعة وجميلة',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'الإصدار: 1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getThemeDescription(ThemeStyle style) {
    switch (style) {
      case ThemeStyle.classicChristmas:
        return 'أحمر وأخضر كلاسيكي لعيد الميلاد';
      case ThemeStyle.winterWonderland:
        return 'أزرق فاتح وثلج لطيف';
      case ThemeStyle.goldenElegance:
        return 'ذهبي أنيق وفخم';
      case ThemeStyle.cozyWarmth:
        return 'برتقالي دافئ ومريح';
      case ThemeStyle.midnightSnow:
        return 'أزرق داكن وثلج ليلي';
    }
  }
}
