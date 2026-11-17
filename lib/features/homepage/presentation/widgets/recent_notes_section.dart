import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/latest_notes_provider.dart';
import 'recent_note_card.dart';

class RecentNotesSection extends ConsumerWidget {
  const RecentNotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(latestNotesProvider);
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: const SectionHeader(title: 'Son Notlar'),
        ),
        SizedBox(height: AppSpacing.md),
        notesAsync.when(
          loading: () => SizedBox(
            height: 190.h,
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Text('Notlar yüklenemedi: $error'),
          ),
          data: (notes) {
            if (notes.isEmpty) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: appColors.border),
                  ),
                  child: Text(
                    'Henüz notun yok. Tara ya da Sesli Not ile ilk notunu ekle.',
                    style: AppTextStyles.body(appColors.textSecondary),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 190.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                itemCount: notes.length,
                separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) =>
                    RecentNoteCard(note: notes[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}