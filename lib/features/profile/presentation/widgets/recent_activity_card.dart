import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/profile_activity.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key, required this.activities});

  final List<ProfileActivity> activities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          children: [
            for (var i = 0; i < activities.length; i++) ...[
              if (i > 0)
                Divider(height: 1, thickness: 1, color: appColors.surfaceMuted),
              _ActivityRow(activity: activities[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final ProfileActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final Color accent = switch (activity.tone) {
      ProfileActivityTone.primary => theme.colorScheme.primary,
      ProfileActivityTone.success => appColors.success,
      ProfileActivityTone.neutral => appColors.textSecondary,
    };
    final Color background = activity.tone == ProfileActivityTone.neutral
        ? appColors.surfaceMuted
        : accent.withValues(alpha: 0.12);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 6.w,
        vertical: AppSpacing.sm + 4.h,
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.sm - 1.r),
            ),
            child: Icon(activity.icon, size: 15.sp, color: accent),
          ),
          SizedBox(width: AppSpacing.sm + 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(
                    theme.colorScheme.onSurface,
                  ).copyWith(fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2.h),
                Text(
                  activity.timeLabel,
                  style: AppTextStyles.metadata(
                    appColors.textTertiary,
                  ).copyWith(fontSize: 10.5.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
