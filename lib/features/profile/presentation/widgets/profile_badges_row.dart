import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/profile_badge.dart';

class ProfileBadgesRow extends StatelessWidget {
  const ProfileBadgesRow({super.key, required this.badges});

  final List<ProfileBadge> badges;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < badges.length; i++) ...[
          if (i > 0) SizedBox(width: AppSpacing.md),
          _BadgeItem(badge: badges[i]),
        ],
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({required this.badge});

  final ProfileBadge badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final accent = badge.unlocked
        ? theme.colorScheme.primary
        : appColors.textTertiary;
    final background = badge.unlocked
        ? theme.colorScheme.primary.withValues(alpha: 0.12)
        : appColors.surfaceMuted;

    return SizedBox(
      width: 58.w,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.md - 2.r),
            ),
            child: Icon(badge.icon, size: 22.sp, color: accent),
          ),
          SizedBox(height: 6.h),
          Text(
            badge.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.metadata(
              appColors.textSecondary,
            ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
