import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/models/detected_object.dart';

const List<Color> _classColors = [
  Color(0xFF3D7BFF),
  Color(0xFFFF9F5A),
  Color(0xFF34C77B),
  Color(0xFF9B6BFF),
  Color(0xFFFF7BAC),
];

Color detectionColorForClass(int classId) =>
    _classColors[classId % _classColors.length];

class DetectionPainter extends CustomPainter {
  DetectionPainter({required this.image, required this.detections});

  final ui.Image image;
  final List<DetectedObject> detections;

  @override
  void paint(Canvas canvas, Size size) {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final destinationSize = applyBoxFit(BoxFit.contain, imageSize, size).destination;
    final destinationOffset = Offset(
      (size.width - destinationSize.width) / 2,
      (size.height - destinationSize.height) / 2,
    );
    final destinationRect = destinationOffset & destinationSize;
    final sourceRect = Offset.zero & imageSize;

    canvas.drawImageRect(image, sourceRect, destinationRect, Paint());

    final scale = destinationSize.width / imageSize.width;

    for (final detection in detections) {
      final color = detectionColorForClass(detection.classId);
      final box = detection.boundingBox;
      final rect = Rect.fromLTRB(
        destinationRect.left + box.left * scale,
        destinationRect.top + box.top * scale,
        destinationRect.left + box.right * scale,
        destinationRect.top + box.bottom * scale,
      );

      canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = color,
      );

      final label =
          '${detection.className} ${(detection.confidence * 100).toStringAsFixed(0)}%';
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelTop = rect.top - textPainter.height - 4;
      final labelBackgroundRect = Rect.fromLTWH(
        rect.left,
        labelTop < 0 ? 0 : labelTop,
        textPainter.width + 8,
        textPainter.height + 4,
      );
      canvas.drawRect(labelBackgroundRect, Paint()..color = color);
      textPainter.paint(
        canvas,
        Offset(labelBackgroundRect.left + 4, labelBackgroundRect.top + 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.detections != detections;
  }
}
