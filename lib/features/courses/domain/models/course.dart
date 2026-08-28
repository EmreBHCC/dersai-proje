import 'package:flutter/material.dart';

import 'course_material.dart';
import 'course_note_preview.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.instructor,
    required this.noteCount,
    required this.progress,
    required this.credit,
    required this.scheduleDay,
    required this.scheduleTime,
    required this.room,
    required this.description,
    required this.materials,
    required this.notes,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String instructor;
  final int noteCount;
  final double progress;
  final int credit;
  final String scheduleDay;
  final String scheduleTime;
  final String room;
  final String description;
  final List<CourseMaterial> materials;
  final List<CourseNotePreview> notes;
}
