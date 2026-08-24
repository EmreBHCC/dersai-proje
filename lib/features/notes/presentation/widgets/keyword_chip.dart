import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class KeywordChip extends StatelessWidget {
  const KeywordChip({super.key, required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final color = highlighted ? theme.colorScheme.primary : appColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: highlighted ? Border.all(color: theme.colorScheme.primary) : null,
      ),
      child: Text(
        label,
        style: AppTextStyles.metadata(color).copyWith(
          fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}
