import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/recent_note.dart';

class RecentNoteCard extends StatelessWidget {
  const RecentNoteCard({super.key, required this.note});

  final RecentNote note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: 170.w,
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: note.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Icon(
                  note.previewIcon,
                  size: 34.sp,
                  color: note.accentColor,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
          ),
          SizedBox(height: 3.h),
          Text(
            note.newItemsLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.metadata(appColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
