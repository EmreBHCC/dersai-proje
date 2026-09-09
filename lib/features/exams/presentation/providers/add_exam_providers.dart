import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/exam_repository.dart';
import '../../domain/models/exam_model.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return const ExamRepository();
});

final myExamsProvider = FutureProvider<List<ExamModel>>((ref) async {
  final repository = ref.watch(examRepositoryProvider);
  return repository.fetchExams();
});