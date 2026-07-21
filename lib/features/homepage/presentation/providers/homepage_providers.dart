import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/homepage_mock_data.dart';
import '../../domain/models/course.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/recent_note.dart';
import '../../domain/models/todays_summary.dart';

final userFirstNameProvider = Provider<String>((ref) {
  return HomepageMockData.userFirstName;
});

final todaysSummaryProvider = Provider<TodaysSummary>((ref) {
  return HomepageMockData.todaysSummary;
});

final quickActionsProvider = Provider<List<QuickAction>>((ref) {
  return HomepageMockData.quickActions;
});

final recentNotesProvider = Provider<List<RecentNote>>((ref) {
  return HomepageMockData.recentNotes;
});

final coursesProvider = Provider<List<Course>>((ref) {
  return HomepageMockData.courses;
});
