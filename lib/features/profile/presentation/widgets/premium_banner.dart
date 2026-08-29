import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm + 1.r),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 19.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppSpacing.sm + 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DersAI Premium',
                    style: AppTextStyles.cardTitle(
                      Colors.white,
                    ).copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Sınırsız tarama ve AI düzeltme',
                    style: AppTextStyles.metadata(
                      Colors.white.withValues(alpha: 0.8),
                    ).copyWith(fontSize: 11.5.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Icon(Icons.chevron_right_rounded, size: 16.sp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
