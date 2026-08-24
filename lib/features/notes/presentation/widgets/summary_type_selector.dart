import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class SummaryTypeSelector extends StatefulWidget {
  const SummaryTypeSelector({super.key});

  static const List<String> options = ['Kısa', 'Detaylı', 'Sınava Hazırlık'];

  @override
  State<SummaryTypeSelector> createState() => _SummaryTypeSelectorState();
}

class _SummaryTypeSelectorState extends State<SummaryTypeSelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          for (var i = 0; i < SummaryTypeSelector.options.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: _selectedIndex == i
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    SummaryTypeSelector.options[i],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonLabel(
                      _selectedIndex == i ? Colors.white : appColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
