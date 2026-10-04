import 'dart:io';

import '../../../detection/domain/models/detected_object.dart';

class NoteGenerationRequest {
  const NoteGenerationRequest({
    required this.imageFile,
    required this.detections,
  });

  final File imageFile;
  final List<DetectedObject> detections;
}
