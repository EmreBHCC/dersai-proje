import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class _HowItWorksStep {
  const _HowItWorksStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  static const List<_HowItWorksStep> _steps = [
    _HowItWorksStep(
      icon: Icons.menu_book_rounded,
      title: 'Derslerini ekle',
      description:
          'Dersler sekmesinden aldığın dersleri ekle. Notların ve sınavların bu derslere göre düzenlenir.',
    ),
    _HowItWorksStep(
      icon: Icons.photo_camera_rounded,
      title: 'Notunu tara',
      description:
          'Tara butonuyla defterinin fotoğrafını çek. Uygulama yazıları tanır ve dijital nota çevirir.',
    ),
    _HowItWorksStep(
      icon: Icons.mic_rounded,
      title: 'Sesli not al',
      description:
          'Yazmak yerine konuş. Söylediklerin yazıya dönüşür ve seçtiğin derse kaydedilir.',
    ),
    _HowItWorksStep(
      icon: Icons.auto_awesome_rounded,
      title: 'Yapay zeka desteği',
      description:
          'Notlarındaki hataları düzeltir, özetler çıkarır ve düzenli bir not hazırlar.',
    ),
    _HowItWorksStep(
      icon: Icons.event_note_rounded,
      title: 'Sınavlarını takip et',
      description:
          'Yaklaşan sınavlarını ekle, tarihini kaçırma. Anasayfada en yakın sınavın görünür.',
    ),
    _HowItWorksStep(
      icon: Icons.person_rounded,
      title: 'İlerlemeni gör',
      description:
          'Profil sayfasında kaç not aldığını, günlük serini ve derslere göre dağılımını takip et.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Nasıl Çalışır?')),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: _steps.length,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final step = _steps[index];
            return Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: appColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      step.icon,
                      color: theme.colorScheme.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${step.title}',
                          style: AppTextStyles.body(
                            theme.colorScheme.onSurface,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          step.description,
                          style: AppTextStyles.body(appColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}