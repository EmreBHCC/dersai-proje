import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_theme_extension.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final line = Expanded(
      child: Container(height: 0.5, color: appColors.border),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'veya',
            style: TextStyle(fontSize: 11.sp, color: appColors.textTertiary),
          ),
        ),
        line,
      ],
    );
  }
}
