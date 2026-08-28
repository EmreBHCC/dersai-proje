import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class ExamCountdownRing extends StatelessWidget {
  const ExamCountdownRing({
    super.key,
    required this.daysRemaining,
    required this.color,
  });

  final int daysRemaining;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isPast = daysRemaining < 0;
    final urgency = isPast
        ? 1.0
        : (1 - (daysRemaining.clamp(0, 30) / 30)).clamp(0.15, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 44.w,
          height: 44.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44.w,
                height: 44.w,
                child: CircularProgressIndicator(
                  value: urgency,
                  strokeWidth: 3.w,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${daysRemaining.abs()}',
                style: AppTextStyles.cardTitle(color),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          isPast ? 'gün önce' : 'gün kaldı',
          style: AppTextStyles.metadata(appColors.textTertiary),
        ),
      ],
    );
  }
}
