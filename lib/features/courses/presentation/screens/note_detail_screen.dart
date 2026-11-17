import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/course_note_preview.dart';

class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key, required this.note});

  final CourseNotePreview note;

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}  ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isVoice = note.type == 'voice_note';

    return Scaffold(
      appBar: AppBar(title: Text(isVoice ? 'Sesli Not' : 'Not')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(note.previewIcon,
                      size: 18.sp, color: theme.colorScheme.primary),
                  SizedBox(width: 6.w),
                  if (note.createdAt != null)
                    Text(
                      _formatDate(note.createdAt!),
                      style: AppTextStyles.metadata(appColors.textSecondary),
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: appColors.border),
                ),
                child: Text(
                  note.content.isEmpty ? 'Bu notun içeriği boş.' : note.content,
                  style: AppTextStyles.body(theme.colorScheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}