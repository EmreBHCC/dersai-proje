import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../courses/domain/models/course_note_preview.dart';
import '../../data/note_repository.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

final courseNotesProvider =
    FutureProvider.family<List<CourseNotePreview>, String>((ref, courseId) async {
  final repository = ref.watch(noteRepositoryProvider);
  final rows = await repository.fetchNotesForCourse(courseId);

  return rows.map((row) {
    final content = row['content'] as String? ?? '';
    final type = row['type'] as String? ?? '';
    final title = content.length > 30 ? '${content.substring(0, 30)}...' : content;

    return CourseNotePreview(
      id: row['id'] as String,
      title: title.isEmpty ? 'Not' : title,
      accentColor: Colors.blue,
      previewIcon: type == 'voice_note' ? Icons.mic_rounded : Icons.description_rounded,
    );
  }).toList();
});