import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/course_note_preview.dart';

class CourseNotesSection extends StatelessWidget {
  const CourseNotesSection({super.key, required this.notes, required this.onAddNote});

  final List<CourseNotePreview> notes;
  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notlarım',
          style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
        ),
        SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: notes.length + 1,
            separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              if (index == notes.length) {
                return _AddNoteTile(onTap: onAddNote);
              }
              return _NotePreviewTile(note: notes[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _NotePreviewTile extends StatelessWidget {
  const _NotePreviewTile({required this.note});

  final CourseNotePreview note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: 110.w,
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: note.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Icon(
                  note.previewIcon,
                  size: 26.sp,
                  color: note.accentColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            note.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.metadata(theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class _AddNoteTile extends StatelessWidget {
  const _AddNoteTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 110.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: appColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 24.sp, color: theme.colorScheme.primary),
            SizedBox(height: 4.h),
            Text(
              'Yeni Not',
              style: AppTextStyles.metadata(theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
