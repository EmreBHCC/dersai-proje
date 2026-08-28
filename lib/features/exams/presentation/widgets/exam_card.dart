import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../../core/utils/turkish_date_formatter.dart';
import '../../domain/models/exam.dart';
import 'exam_countdown_ring.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({super.key, required this.exam, required this.onTap});

  final Exam exam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final daysRemaining = exam.date.difference(DateTime.now()).inDays;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: appColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ExamDateBox(date: exam.date),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.courseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: exam.courseColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        exam.courseCode,
                        style: AppTextStyles.metadata(appColors.textSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  _ExamMetaRow(icon: Icons.access_time_rounded, label: exam.timeRange),
                  SizedBox(height: 4.h),
                  _ExamMetaRow(icon: Icons.location_on_outlined, label: exam.location),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            ExamCountdownRing(daysRemaining: daysRemaining, color: exam.courseColor),
          ],
        ),
      ),
    );
  }
}

class _ExamDateBox extends StatelessWidget {
  const _ExamDateBox({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: 52.w,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Text(
            '${date.day}',
            style: AppTextStyles.statValue(Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(height: 2.h),
          Text(
            TurkishDateFormatter.monthName(date),
            style: AppTextStyles.metadata(appColors.textSecondary),
          ),
          Text(
            TurkishDateFormatter.weekdayShort(date),
            style: AppTextStyles.metadata(appColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _ExamMetaRow extends StatelessWidget {
  const _ExamMetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      children: [
        Icon(icon, size: 14.sp, color: appColors.textTertiary),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(appColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
