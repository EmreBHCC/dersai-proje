import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/streak_day.dart';

class WeeklyStreakCard extends StatelessWidget {
  const WeeklyStreakCard({super.key, required this.streak});

  final WeeklyStreak streak;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                streak.title,
                style: AppTextStyles.body(
                  theme.colorScheme.onSurface,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                streak.statusLabel,
                style: AppTextStyles.metadata(appColors.warning),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md - 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (final day in streak.days) _StreakDayCell(day: day)],
          ),
        ],
      ),
    );
  }
}

class _StreakDayCell extends StatelessWidget {
  const _StreakDayCell({required this.day});

  final StreakDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final Color fill;
    if (day.isToday) {
      fill = appColors.warning;
    } else if (day.completed) {
      fill = theme.colorScheme.primary;
    } else {
      fill = appColors.surfaceMuted;
    }

    return Column(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.sm - 2.r),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          day.label,
          style: AppTextStyles.metadata(
            appColors.textTertiary,
          ).copyWith(fontSize: 10.sp),
        ),
      ],
    );
  }
}
