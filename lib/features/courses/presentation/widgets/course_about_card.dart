import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class CourseAboutCard extends StatelessWidget {
  const CourseAboutCard({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ders Hakkında',
                  style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                ),
              ),
              Icon(
                Icons.auto_awesome_outlined,
                size: 16.sp,
                color: appColors.textTertiary,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(description, style: AppTextStyles.body(appColors.textSecondary)),
        ],
      ),
    );
  }
}
