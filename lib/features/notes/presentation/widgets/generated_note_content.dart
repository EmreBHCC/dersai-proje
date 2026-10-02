import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/generated_note.dart';
import 'generated_note_section_card.dart';
import 'keyword_chip.dart';

class GeneratedNoteContent extends StatelessWidget {
  const GeneratedNoteContent({super.key, required this.note});

  final GeneratedNote note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title,
          style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            note.summary,
            style: AppTextStyles.body(appColors.textSecondary),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        for (final section in note.sections) ...[
          GeneratedNoteSectionCard(section: section),
          SizedBox(height: AppSpacing.md),
        ],
        if (note.keyPoints.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          Text(
            'Önemli Noktalar',
            style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final point in note.keyPoints) KeywordChip(label: point),
            ],
          ),
        ],
      ],
    );
  }
}
