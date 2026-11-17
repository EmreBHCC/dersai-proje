import 'package:flutter/material.dart';

class CourseNotePreview {
  const CourseNotePreview({
    required this.id,
    required this.title,
    required this.accentColor,
    required this.previewIcon,
    this.content = '',
    this.createdAt,
    this.type = '',
  });

  final String id;
  final String title;
  final Color accentColor;
  final IconData previewIcon;
  final String content;
  final DateTime? createdAt;
  final String type;
}