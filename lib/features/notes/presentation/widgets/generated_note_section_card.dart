import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/generated_note.dart';

class GeneratedNoteSectionCard extends StatelessWidget {
  const GeneratedNoteSectionCard({super.key, required this.section});

  final GeneratedNoteSection section;

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
          Text(
            section.heading,
            style: AppTextStyles.cardTitle(theme.colorScheme.onSurface),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            section.explanation,
            style: AppTextStyles.body(appColors.textSecondary),
          ),
          if (section.examples.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              'Örnekler',
              style: AppTextStyles.metadata(theme.colorScheme.primary),
            ),
            SizedBox(height: AppSpacing.xs),
            for (final example in section.examples)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: AppTextStyles.body(appColors.textSecondary),
                    ),
                    Expanded(
                      child: Text(
                        example,
                        style: AppTextStyles.body(theme.colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
