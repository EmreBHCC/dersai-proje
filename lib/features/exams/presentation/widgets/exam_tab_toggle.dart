import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

enum ExamListTab { upcoming, past }

class ExamTabToggle extends StatelessWidget {
  const ExamTabToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ExamListTab selected;
  final ValueChanged<ExamListTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabChip(
            label: 'Yaklaşan',
            isActive: selected == ExamListTab.upcoming,
            onTap: () => onChanged(ExamListTab.upcoming),
          ),
          _TabChip(
            label: 'Geçmiş',
            isActive: selected == ExamListTab.past,
            onTap: () => onChanged(ExamListTab.past),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLabel(
            isActive ? Colors.white : appColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
