import 'package:flutter/material.dart';

class Exam {
  const Exam({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.courseColor,
    required this.date,
    required this.timeRange,
    required this.location,
    required this.instructor,
    required this.examType,
    required this.weightPercent,
    required this.description,
    required this.studyPlanCompleted,
    required this.studyPlanTotal,
  });

  final String id;
  final String courseCode;
  final String courseName;
  final Color courseColor;
  final DateTime date;
  final String timeRange;
  final String location;
  final String instructor;
  final String examType;
  final int weightPercent;
  final String description;
  final int studyPlanCompleted;
  final int studyPlanTotal;
}
