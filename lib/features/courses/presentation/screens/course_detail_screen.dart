import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/course.dart';
import '../widgets/course_about_card.dart';
import '../widgets/course_header_card.dart';
import '../widgets/course_materials_card.dart';
import '../widgets/course_notes_section.dart';
import '../widgets/course_stats_row.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
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
              CourseNotesSection(notes: course.notes, onAddNote: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
