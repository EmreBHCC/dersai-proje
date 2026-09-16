import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/note_repository.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});