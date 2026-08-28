import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/exam.dart';

class ExamDetailInfoCard extends StatelessWidget {
  const ExamDetailInfoCard({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.menu_book_outlined, label: 'Ders', value: exam.courseName),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Öğretim Üyesi',
            value: exam.instructor,
          ),
          _InfoRow(
            icon: Icons.description_outlined,
            label: 'Sınav Türü',
            value: exam.examType,
          ),
          _InfoRow(
            icon: Icons.percent_rounded,
            label: 'Ağırlık',
            value: '%${exam.weightPercent}',
          ),
          _InfoRow(icon: Icons.location_on_outlined, label: 'Salon', value: exam.location),
          _InfoRow(
            icon: Icons.notes_rounded,
            label: 'Açıklama',
            value: exam.description,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm + 2.h),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: appColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: appColors.textTertiary),
          SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.body(appColors.textSecondary)),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
