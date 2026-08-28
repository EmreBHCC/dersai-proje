import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/course.dart';

class CourseStatsRow extends StatelessWidget {
  const CourseStatsRow({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatItem(
              icon: Icons.calendar_today_outlined,
              label: 'Gün',
              value: course.scheduleDay,
            ),
            _StatDivider(color: appColors.border),
            _StatItem(
              icon: Icons.access_time_rounded,
              label: 'Saat',
              value: course.scheduleTime,
            ),
            _StatDivider(color: appColors.border),
            _StatItem(
              icon: Icons.location_on_outlined,
              label: 'Derslik',
              value: course.room,
            ),
            _StatDivider(color: appColors.border),
            _StatItem(
              icon: Icons.workspace_premium_outlined,
              label: 'AKTS',
              value: '${course.credit}',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18.sp, color: appColors.textTertiary),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.metadata(theme.colorScheme.onSurface)
                  .copyWith(fontSize: 13.sp, height: 1.2),
            ),
          ),
          SizedBox(height: 2.h),
          Text(label, style: AppTextStyles.metadata(appColors.textTertiary)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(width: 1, thickness: 1, color: color);
  }
}
