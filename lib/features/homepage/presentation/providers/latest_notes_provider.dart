import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notes/presentation/providers/note_providers.dart';
import '../../domain/models/recent_note.dart';

String _two(int n) => n.toString().padLeft(2, '0');

final latestNotesProvider =
    FutureProvider.autoDispose<List<RecentNote>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  final rows = await repository.fetchRecentNotes();

  return rows.map((row) {
    final content = row['content'] as String? ?? '';
    final type = row['type'] as String? ?? '';
    final createdRaw = row['created_at'] as String?;
    final createdAt =
        createdRaw == null ? null : DateTime.tryParse(createdRaw)?.toLocal();
    final title =
        content.length > 30 ? '${content.substring(0, 30)}...' : content;
    final typeLabel = type == 'voice_note' ? 'Sesli not' : 'Not';
    final dateLabel = createdAt == null
        ? ''
        : ' · ${_two(createdAt.day)}.${_two(createdAt.month)}';

    return RecentNote(
      id: row['id'] as String,
      title: title.isEmpty ? 'Not' : title,
      newItemsLabel: '$typeLabel$dateLabel',
      accentColor: Colors.blue,
      previewIcon:
          type == 'voice_note' ? Icons.mic_rounded : Icons.description_rounded,
      content: content,
      createdAt: createdAt,
      type: type,
    );
  }).toList();
});