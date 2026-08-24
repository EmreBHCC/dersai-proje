import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../widgets/info_banner.dart';
import '../widgets/rich_text_toolbar.dart';
import 'ai_summary_screen.dart';

class ProcessedTextScreen extends StatelessWidget {
  const ProcessedTextScreen({super.key});

  static const List<String> _axioms = [
    'u + v = v + u',
    'u + (v + w) = (u + v) + w',
    'u + 0 = u',
    'u + (-u) = 0',
    'a(u + v) = au + av',
    '(a + b)u = au + bu',
    'a(bu) = (ab)u',
    '1·u = u',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('İşlenmiş Metni Kaydet')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoBanner(
                message:
                    'Bu metin, modelin OCR çıktısından işlediği temiz halidir. '
                    'Kaydettiğinde AI ile Özetle sayfasına yönlendirileceksin.',
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'İşlenmiş Metin',
                style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
              ),
              SizedBox(height: AppSpacing.sm),
              const RichTextToolbar(),
              SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: appColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vektör Uzayları',
                      style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tanım: ',
                            style: AppTextStyles.body(theme.colorScheme.onSurface)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: 'Bir vektör uzayı, toplama ve skaler çarpma '
                                'işlemlerine göre kapalı olan bir kümedir.',
                            style: AppTextStyles.body(appColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Aksiyomlar',
                      style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    for (var i = 0; i < _axioms.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          '${i + 1}. ${_axioms[i]}',
                          style: AppTextStyles.body(appColors.textSecondary),
                        ),
                      ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Düzenlemek için metne dokun',
                      style: AppTextStyles.metadata(appColors.textTertiary),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AiSummaryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kaydet ve Özetle\'ye Git',
                        style: AppTextStyles.buttonLabel(Colors.white),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
