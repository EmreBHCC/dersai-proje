import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md - 2.r),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm + 5.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md - 2.r),
          border: Border.all(color: appColors.border),
        ),
        child: Text(
          'Çıkış Yap',
          style: AppTextStyles.buttonLabel(
            AppColors.error,
          ).copyWith(fontSize: 13.5.sp),
        ),
      ),
    );
  }
}
