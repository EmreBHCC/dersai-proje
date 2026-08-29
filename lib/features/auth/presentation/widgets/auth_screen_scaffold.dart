import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';

/// Full-bleed auth page shell: fills the whole phone screen, keeps the content
/// pinned to the safe area, and falls back to scrolling only when the keyboard
/// leaves too little room. [children] are laid out in a stretched [Column]; use
/// a [Spacer] among them to push the call-to-action block to the bottom.
class AuthScreenScaffold extends StatelessWidget {
  const AuthScreenScaffold({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
