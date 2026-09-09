import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../domain/models/course_model.dart';

class CourseRepository {
  const CourseRepository();

  SupabaseClient get _client => SupabaseService.client;

  Future<List<CourseModel>> fetchCourses() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Kullanıcı oturumu bulunamadı');
    }

    final response = await _client
        .from('dersler')
        .select()
        .eq('user_id', userId)
        .order('created_at');

    return (response as List)
        .map((row) => CourseModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCourse(CourseModel course) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Kullanıcı oturumu bulunamadı');
    }

    await _client.from('dersler').insert({
            ...course.toInsertJson(),
      'user_id': userId,
    });
  }
}