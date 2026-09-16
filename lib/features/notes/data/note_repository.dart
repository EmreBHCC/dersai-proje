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
}