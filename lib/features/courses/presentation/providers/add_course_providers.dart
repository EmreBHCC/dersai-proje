import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/course_repository.dart';
import '../../domain/models/course_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return const CourseRepository();
});

final myCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.fetchCourses();
});