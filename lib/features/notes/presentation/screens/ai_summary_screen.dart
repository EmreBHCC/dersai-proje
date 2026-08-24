import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../widgets/info_banner.dart';
import '../widgets/keyword_chip.dart';
import '../widgets/summary_type_selector.dart';

class AiSummaryScreen extends StatelessWidget {
  const AiSummaryScreen({super.key});

  static const List<String> _summaryPoints = [
    'Vektör uzay, toplama ve skaler çarpma işlemlerine göre kapalıdır.',
    '8 temel aksiyom vardır.',
    'Alt uzay, belirli koşulları sağlayan boş olmayan alt kümedir.',
    'Lineer bağımlılık ve bağımsızlık kavramları vektör uzayının temel yapı taşlarıdır.',
    'Baz ve boyut, vektör uzayının boyutunu belirler.',
  ];

  static const List<({String label, bool highlighted})> _keywords = [
    (label: 'Vektör Uzayı', highlighted: false),
    (label: 'Aksiyomlar', highlighted: false),
    (label: 'Alt Uzay', highlighted: false),
    (label: 'Lineer Bağımlılık', highlighted: true),
    (label: 'Baz', highlighted: false),
    (label: 'Boyut', highlighted: false),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('AI ile Özetle')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Özet Türü',
                style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
              ),
              SizedBox(height: AppSpacing.sm),
              const SummaryTypeSelector(),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Özet',
                style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
              ),
              SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          size: 18.sp,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Doğrusal Cebir – Ders 5',
                            style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    for (final point in _summaryPoints)
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('•  ', style: AppTextStyles.body(appColors.textSecondary)),
                            Expanded(
                              child: Text(point, style: AppTextStyles.body(appColors.textSecondary)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Anahtar Kelimeler',
                style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
              ),
              SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final keyword in _keywords)
                    KeywordChip(label: keyword.label, highlighted: keyword.highlighted),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              const InfoBanner(
                message: 'Bu özet AI tarafından oluşturuldu. Dilersen düzenleyebilirsin.',
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52.h,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 18),
                        label: Text('Paylaş', style: AppTextStyles.buttonLabel(Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: SizedBox(
                      height: 52.h,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.copy_rounded, color: theme.colorScheme.primary, size: 18),
                        label: Text(
                          'Kopyala',
                          style: AppTextStyles.buttonLabel(theme.colorScheme.primary),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: appColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
