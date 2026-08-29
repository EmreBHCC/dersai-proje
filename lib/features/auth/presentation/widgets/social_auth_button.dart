import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';

/// Outlined "continue with `provider`" button used for Google / Apple sign-in.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconSize,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          border: Border.all(color: AppColors.lightBorder, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? 16.sp,
              color: AppColors.lightTextPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
