class NoteGenerationException implements Exception {
  const NoteGenerationException(this.message);

  final String message;

  @override
  String toString() => message;
}
