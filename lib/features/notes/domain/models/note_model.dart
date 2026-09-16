class NoteModel {
  NoteModel({
    required this.content,
    required this.type,
    this.subjectId,
  });

  final String content;
  final String type;
  final String? subjectId;

  Map<String, dynamic> toInsertJson(String userId) {
    return {
      'user_id': userId,
      'subject_id': subjectId,
      'type': type,
      'content': content,
    };
  }
}