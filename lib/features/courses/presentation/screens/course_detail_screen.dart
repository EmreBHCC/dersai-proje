import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../notes/presentation/providers/note_providers.dart';
import '../../../notes/presentation/screens/voice_note_screen.dart';
import '../../domain/models/course.dart';
import '../widgets/course_about_card.dart';
import '../widgets/course_header_card.dart';
import '../widgets/course_materials_card.dart';
import '../widgets/course_notes_section.dart';
import '../widgets/course_stats_row.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(courseNotesProvider(course.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders Detayı'),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CourseHeaderCard(course: course),
              SizedBox(height: AppSpacing.lg),
              CourseStatsRow(course: course),
              SizedBox(height: AppSpacing.lg),
              CourseAboutCard(description: course.description),
              SizedBox(height: AppSpacing.lg),
              CourseMaterialsCard(materials: course.materials),
              SizedBox(height: AppSpacing.lg),
              notesAsync.when(
                data: (notes) => CourseNotesSection(
                  notes: notes,
                  onAddNote: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VoiceNoteScreen(courseId: course.id),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Notlar yüklenemedi: $error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}