import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';

/// Horizontal rule with a centered "veya" label.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 0.5, color: AppColors.lightBorder),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'veya',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.lightTextTertiary,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
