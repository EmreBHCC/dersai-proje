import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_extension.dart';

class RichTextToolbar extends StatelessWidget {
  const RichTextToolbar({super.key});

  static const List<IconData> _leadingIcons = [
    Icons.format_bold_rounded,
    Icons.format_italic_rounded,
    Icons.format_underlined_rounded,
    Icons.format_list_bulleted_rounded,
    Icons.format_list_numbered_rounded,
    Icons.text_fields_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          for (final icon in _leadingIcons) _ToolbarIcon(icon: icon),
          const Spacer(),
          const _ToolbarIcon(icon: Icons.open_in_full_rounded),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Icon(icon, size: 18.sp, color: appColors.textSecondary),
    );
  }
}
