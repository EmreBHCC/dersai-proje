import 'package:flutter/material.dart';

class Course {
  const Course({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.noteCount,
    required this.progress,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int noteCount;
  final double progress;
}
