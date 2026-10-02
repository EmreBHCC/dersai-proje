class GeneratedNoteSection {
  const GeneratedNoteSection({
    required this.heading,
    required this.explanation,
    this.examples = const [],
  });

  factory GeneratedNoteSection.fromJson(Map<String, dynamic> json) {
    return GeneratedNoteSection(
      heading: json['heading'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      examples: _stringList(json['examples']),
    );
  }

  final String heading;
  final String explanation;
  final List<String> examples;
}

class GeneratedNote {
  const GeneratedNote({
    required this.title,
    required this.summary,
    required this.sections,
    required this.keyPoints,
  });

  factory GeneratedNote.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'] as List<dynamic>? ?? const [];
    return GeneratedNote(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      sections: rawSections
          .whereType<Map<String, dynamic>>()
          .map(GeneratedNoteSection.fromJson)
          .toList(),
      keyPoints: _stringList(json['key_points']),
    );
  }

  final String title;
  final String summary;
  final List<GeneratedNoteSection> sections;
  final List<String> keyPoints;

  String toMarkdown() {
    final buffer = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln(summary);

    for (final section in sections) {
      buffer
        ..writeln()
        ..writeln('## ${section.heading}')
        ..writeln()
        ..writeln(section.explanation);
      if (section.examples.isNotEmpty) {
        buffer
          ..writeln()
          ..writeln('Örnekler:');
        for (final example in section.examples) {
          buffer.writeln('- $example');
        }
      }
    }

    if (keyPoints.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('## Önemli Noktalar')
        ..writeln();
      for (final point in keyPoints) {
        buffer.writeln('- $point');
      }
    }

    return buffer.toString().trimRight();
  }
}

List<String> _stringList(Object? value) {
  if (value is! List<dynamic>) return const [];
  return value.whereType<String>().toList();
}
