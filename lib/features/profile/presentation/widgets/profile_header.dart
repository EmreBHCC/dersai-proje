import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = Colors.white;

    return Container(
      color: theme.colorScheme.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _HeaderIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {},
                  ),
                  SizedBox(width: AppSpacing.md),
                  _HeaderIconButton(
                    icon: Icons.wb_sunny_outlined,
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _ProfileAvatar(initials: profile.initials),
                  SizedBox(width: AppSpacing.md - 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          style: AppTextStyles.sectionTitle(
                            onPrimary,
                          ).copyWith(fontSize: 19.sp),
                        ),
                        SizedBox(height: 6.h),
                        _VerifiedChip(label: profile.verifiedLabel),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg - 2.h),
              Container(
                padding: EdgeInsets.only(top: AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: onPrimary.withValues(alpha: 0.15)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final stat in profile.stats)
                      _HeaderStat(value: stat.value, label: stat.label),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Icon(icon, size: 20.sp, color: Colors.white),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return SizedBox(
      width: 60.w,
      height: 60.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: Text(initials, style: AppTextStyles.statValue(Colors.white)),
          ),
          Positioned(
            bottom: -2.h,
            right: -2.w,
            child: Container(
              width: 22.w,
              height: 22.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: appColors.warning,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                size: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 12.sp,
            color: appColors.success,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.metadata(
              Colors.white,
            ).copyWith(fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.statValue(Colors.white)),
        SizedBox(height: 2.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.metadata(
            Colors.white.withValues(alpha: 0.7),
          ).copyWith(fontSize: 10.sp, height: 1.25),
        ),
      ],
    );
  }
}
