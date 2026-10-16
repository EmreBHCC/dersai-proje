class NoteModel {
  NoteModel({
    required this.content,
    required this.type,
    this.subjectId,
    this.audioUrl,
  });

  final String content;
  final String type;
  final String? subjectId;
  final String? audioUrl;

  Map<String, dynamic> toInsertJson(String userId) {
    final json = <String, dynamic>{
      'user_id': userId,
      'subject_id': subjectId,
      'type': type,
      'content': content,
    };

    if (audioUrl != null) {
      json['audio_url'] = audioUrl;
    }

    return json;
  }
}