import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/subject_distribution.dart';

class SubjectDistributionCard extends StatelessWidget {
  const SubjectDistributionCard({super.key, required this.subjects});

  final List<SubjectDistribution> subjects;

  // Opacity steps keep the design's visual hierarchy while staying on a single
  // accent colour (AppColors.primary).
  static const List<double> _fillOpacities = [1.0, 0.72, 0.5, 0.32];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < subjects.length; i++) ...[
            if (i > 0) SizedBox(height: AppSpacing.md - 2.h),
            _SubjectRow(
              subject: subjects[i],
              fillColor: theme.colorScheme.primary.withValues(
                alpha: _fillOpacities[i.clamp(0, _fillOpacities.length - 1)],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.subject, required this.fillColor});

  final SubjectDistribution subject;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject.name,
              style: AppTextStyles.metadata(
                theme.colorScheme.onSurface,
              ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              '${subject.noteCount} not',
              style: AppTextStyles.metadata(
                appColors.textTertiary,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: subject.ratio,
            minHeight: 6.h,
            backgroundColor: appColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          ),
        ),
      ],
    );
  }
}
