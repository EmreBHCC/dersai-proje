import 'package:flutter/material.dart';

class DetectedObject {
  const DetectedObject({
    required this.classId,
    required this.className,
    required this.confidence,
    required this.boundingBox,
  });

  final int classId;
  final String className;
  final double confidence;

  /// Bounding box in the original image's pixel coordinates.
  final Rect boundingBox;
}
