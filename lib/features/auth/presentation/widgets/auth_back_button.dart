import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 22.sp,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
