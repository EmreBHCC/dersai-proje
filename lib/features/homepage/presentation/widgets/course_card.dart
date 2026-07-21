import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/course.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final progressPercent = (course.progress * 100).round();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: course.color,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(course.icon, size: 22.sp, color: Colors.white),
          ),
          SizedBox(height: AppSpacing.sm + 4.h),
          Text(
            course.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
          ),
          SizedBox(height: 2.h),
          Text(
            '${course.noteCount} not',
            style: AppTextStyles.metadata(appColors.textSecondary),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: course.progress,
              minHeight: 6.h,
              backgroundColor: appColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(course.color),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '%$progressPercent tamamlandı',
            style: AppTextStyles.metadata(appColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
