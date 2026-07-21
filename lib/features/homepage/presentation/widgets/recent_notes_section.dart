import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/models/recent_note.dart';
import 'recent_note_card.dart';

class RecentNotesSection extends StatelessWidget {
  const RecentNotesSection({super.key, required this.notes});

  final List<RecentNote> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: const SectionHeader(title: 'Son Notlar'),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 190.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            itemCount: notes.length,
            separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) => RecentNoteCard(note: notes[index]),
          ),
        ),
      ],
    );
  }
}
