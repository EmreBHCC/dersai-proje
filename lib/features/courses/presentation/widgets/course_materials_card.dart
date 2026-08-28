import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/course_material.dart';

class CourseMaterialsCard extends StatelessWidget {
  const CourseMaterialsCard({super.key, required this.materials});

  final List<CourseMaterial> materials;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Ders Materyalleri',
                    style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < materials.length; i++)
            _MaterialRow(
              material: materials[i],
              isLast: i == materials.length - 1,
            ),
        ],
      ),
    );
  }
}

class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.material, required this.isLast});

  final CourseMaterial material;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm + 2.h),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: appColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.picture_as_pdf_outlined,
              size: 18.sp,
              color: theme.colorScheme.error,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${material.fileType} • ${material.date}',
                  style: AppTextStyles.metadata(appColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.file_download_outlined,
            size: 20.sp,
            color: appColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
