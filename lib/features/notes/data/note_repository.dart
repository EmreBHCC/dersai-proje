import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/note_model.dart';

class NoteRepository {
  final _supabase = Supabase.instance.client;

  Future<void> saveNote(NoteModel note) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Kullanıcı bulunamadı');
    }
    await _supabase.from('notes').insert(note.toInsertJson(userId));
  }

  Future<List<Map<String, dynamic>>> fetchNotesForCourse(String subjectId) async {
    final response = await _supabase
        .from('notes')
        .select()
        .eq('subject_id', subjectId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<String> uploadAudio(File file) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Kullanıcı bulunamadı');
    }
    final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _supabase.storage.from('voice-notes').upload(fileName, file);
    return _supabase.storage.from('voice-notes').getPublicUrl(fileName);
  }
}