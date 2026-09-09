import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../domain/models/exam_model.dart';

class ExamRepository {
  const ExamRepository();

  SupabaseClient get _client => SupabaseService.client;

  Future<List<ExamModel>> fetchExams() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Kullanıcı oturumu bulunamadı');
    }

    final response = await _client
        .from('sinavlar')
        .select()
        .eq('user_id', userId)
        .order('tarih_saat');

    return (response as List)
        .map((row) => ExamModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> addExam(ExamModel exam) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Kullanıcı oturumu bulunamadı');
    }

    await _client.from('sinavlar').insert({
      ...exam.toInsertJson(),
      'user_id': userId,
    });
  }
}