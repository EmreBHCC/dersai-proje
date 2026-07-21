import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/models/course.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/recent_note.dart';
import '../../domain/models/todays_summary.dart';

abstract final class HomepageMockData {
  static const String userFirstName = 'Levent';

  static const TodaysSummary todaysSummary = TodaysSummary(
    icon: Icons.event_note_outlined,
    title: 'Yaklaşan Sınav',
    subtitle: 'Fizik, 12 Ekim',
    metaIcon: Icons.access_time_rounded,
    metaLabel: 'Bugün 4 yeni tarama',
  );

  static const List<QuickAction> quickActions = [
    QuickAction(
      id: 'how-it-works',
      icon: Icons.help_outline_rounded,
      label: 'Nasıl Çalışır',
    ),
    QuickAction(
      id: 'scan',
      icon: Icons.camera_alt_rounded,
      label: 'Tara',
      isPrimary: true,
    ),
    QuickAction(
      id: 'voice',
      icon: Icons.mic_none_rounded,
      label: 'Sesli Not',
    ),
  ];

  static const List<RecentNote> recentNotes = [
    RecentNote(
      id: 'note-1',
      title: 'Ağaçlar ve Dolaşma',
      newItemsLabel: '3 yeni not',
      accentColor: AppColors.courseBlue,
      previewIcon: Icons.account_tree_outlined,
    ),
    RecentNote(
      id: 'note-2',
      title: 'II. Dünya Savaşı Girişi',
      newItemsLabel: '4 yeni not',
      accentColor: AppColors.courseOrange,
      previewIcon: Icons.public_outlined,
    ),
    RecentNote(
      id: 'note-3',
      title: 'Enzim Kinetiği',
      newItemsLabel: '2 yeni not',
      accentColor: AppColors.courseGreen,
      previewIcon: Icons.science_outlined,
    ),
    RecentNote(
      id: 'note-4',
      title: 'Özdeğer ve Özvektörler',
      newItemsLabel: '5 yeni not',
      accentColor: AppColors.coursePurple,
      previewIcon: Icons.grid_on_outlined,
    ),
  ];

  static const List<Course> courses = [
    Course(
      id: 'course-1',
      name: 'Veri Yapıları ve Algoritmalar',
      icon: Icons.integration_instructions_outlined,
      color: AppColors.courseBlue,
      noteCount: 18,
      progress: 0.72,
    ),
    Course(
      id: 'course-2',
      name: 'Organik Kimya',
      icon: Icons.biotech_outlined,
      color: AppColors.courseGreen,
      noteCount: 12,
      progress: 0.45,
    ),
    Course(
      id: 'course-3',
      name: 'Dünya Tarihi',
      icon: Icons.language_outlined,
      color: AppColors.courseOrange,
      noteCount: 9,
      progress: 0.6,
    ),
    Course(
      id: 'course-4',
      name: 'Lineer Cebir',
      icon: Icons.calculate_outlined,
      color: AppColors.coursePurple,
      noteCount: 15,
      progress: 0.3,
    ),
  ];
}
