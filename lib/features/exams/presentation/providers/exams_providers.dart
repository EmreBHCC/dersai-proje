import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/exams_mock_data.dart';
import '../../domain/models/exam.dart';

final upcomingExamsProvider = Provider<List<Exam>>((ref) {
  return ExamsMockData.upcoming;
});

final pastExamsProvider = Provider<List<Exam>>((ref) {
  return ExamsMockData.past;
});
