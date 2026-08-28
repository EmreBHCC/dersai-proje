import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/courses_mock_data.dart';
import '../../domain/models/course.dart';

final allCoursesProvider = Provider<List<Course>>((ref) {
  return CoursesMockData.courses;
});
