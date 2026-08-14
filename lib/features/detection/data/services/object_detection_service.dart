import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../domain/models/detected_object.dart';

typedef _LetterboxResult = ({
  img.Image canvas,
  double scale,
  int padX,
  int padY,
});

class ObjectDetectionService {
  ObjectDetectionService({
    this.modelAsset = 'assets/models/best_float16.tflite',
    this.labelsAsset = 'assets/models/labels.txt',
    this.confidenceThreshold = 0.4,
    this.iouThreshold = 0.45,
  });

  final String modelAsset;
  final String labelsAsset;
  final double confidenceThreshold;
  final double iouThreshold;

  static const int _inputSize = 640;

  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> _ensureLoaded() async {
    if (_interpreter != null && _labels != null) return;
    _interpreter ??= await Interpreter.fromAsset(modelAsset);
    final rawLabels = await rootBundle.loadString(labelsAsset);
    _labels = rawLabels
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<List<DetectedObject>> detect(File imageFile) async {
    await _ensureLoaded();
    final interpreter = _interpreter!;
    final labels = _labels!;

    final bytes = await imageFile.readAsBytes();
    final source = img.decodeImage(bytes);
    if (source == null) {
      throw StateError('Görsel çözümlenemedi.');
    }

    final letterboxed = _letterbox(source, _inputSize);
    final input = _imageToInputTensor(letterboxed.canvas, _inputSize);

    final outputShape = interpreter.getOutputTensor(0).shape;
    final output = _buildOutputBuffer(outputShape);
    interpreter.run(input, output);

    final detections = _decodeOutput(
      output: output,
      outputShape: outputShape,
      labels: labels,
      letterbox: letterboxed,
      originalWidth: source.width,
      originalHeight: source.height,
    );

    return _nonMaxSuppression(detections, iouThreshold);
  }

  _LetterboxResult _letterbox(img.Image source, int size) {
    final scale = math.min(size / source.width, size / source.height);
    final newWidth = (source.width * scale).round();
    final newHeight = (source.height * scale).round();

    final resized = img.copyResize(
      source,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear,
    );

    final canvas = img.Image(width: size, height: size);
    img.fill(canvas, color: img.ColorRgb8(114, 114, 114));

    final padX = ((size - newWidth) / 2).floor();
    final padY = ((size - newHeight) / 2).floor();
    img.compositeImage(canvas, resized, dstX: padX, dstY: padY);

    return (canvas: canvas, scale: scale, padX: padX, padY: padY);
  }

  List<List<List<List<double>>>> _imageToInputTensor(
    img.Image canvas,
    int size,
  ) {
    return List.generate(
      1,
      (_) => List.generate(
        size,
        (y) => List.generate(size, (x) {
          final pixel = canvas.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );
  }

  dynamic _buildOutputBuffer(List<int> shape) {
    if (shape.length == 1) {
      return List<double>.filled(shape[0], 0.0);
    }
    return List.generate(shape[0], (_) => _buildOutputBuffer(shape.sublist(1)));
  }

  List<DetectedObject> _decodeOutput({
    required dynamic output,
    required List<int> outputShape,
    required List<String> labels,
    required _LetterboxResult letterbox,
    required int originalWidth,
    required int originalHeight,
  }) {
    final numClasses = labels.length;
    final featuresLen = 4 + numClasses;
    final dim1 = outputShape[1];
    final dim2 = outputShape[2];

    final bool channelsFirst;
    final int numAnchors;
    if (dim1 == featuresLen) {
      channelsFirst = true;
      numAnchors = dim2;
    } else if (dim2 == featuresLen) {
      channelsFirst = false;
      numAnchors = dim1;
    } else {
      channelsFirst = dim1 < dim2;
      numAnchors = channelsFirst ? dim2 : dim1;
    }

    double valueAt(int anchor, int feature) {
      final row = output[0];
      if (channelsFirst) {
        return (row[feature][anchor] as num).toDouble();
      }
      return (row[anchor][feature] as num).toDouble();
    }

    final results = <DetectedObject>[];
    for (var anchor = 0; anchor < numAnchors; anchor++) {
      var bestClassId = 0;
      var bestScore = 0.0;
      for (var c = 0; c < numClasses; c++) {
        final score = valueAt(anchor, 4 + c);
        if (score > bestScore) {
          bestScore = score;
          bestClassId = c;
        }
      }
      if (bestScore < confidenceThreshold) continue;

      // The exported model emits box coordinates normalized to [0, 1]
      // relative to the 640x640 input, not absolute input-pixel values.
      final cx = valueAt(anchor, 0) * _inputSize;
      final cy = valueAt(anchor, 1) * _inputSize;
      final w = valueAt(anchor, 2) * _inputSize;
      final h = valueAt(anchor, 3) * _inputSize;

      final x1 = (cx - w / 2 - letterbox.padX) / letterbox.scale;
      final y1 = (cy - h / 2 - letterbox.padY) / letterbox.scale;
      final x2 = (cx + w / 2 - letterbox.padX) / letterbox.scale;
      final y2 = (cy + h / 2 - letterbox.padY) / letterbox.scale;

      final rect = Rect.fromLTRB(
        x1.clamp(0, originalWidth.toDouble()),
        y1.clamp(0, originalHeight.toDouble()),
        x2.clamp(0, originalWidth.toDouble()),
        y2.clamp(0, originalHeight.toDouble()),
      );
      if (rect.width <= 0 || rect.height <= 0) continue;

      results.add(
        DetectedObject(
          classId: bestClassId,
          className: labels[bestClassId],
          confidence: bestScore,
          boundingBox: rect,
        ),
      );
    }
    return results;
  }

  List<DetectedObject> _nonMaxSuppression(
    List<DetectedObject> boxes,
    double iouThreshold,
  ) {
    final byClass = <int, List<DetectedObject>>{};
    for (final box in boxes) {
      byClass.putIfAbsent(box.classId, () => []).add(box);
    }

    final kept = <DetectedObject>[];
    for (final classBoxes in byClass.values) {
      classBoxes.sort((a, b) => b.confidence.compareTo(a.confidence));
      final selected = <DetectedObject>[];
      for (final candidate in classBoxes) {
        final overlaps = selected.any(
          (s) => _iou(candidate.boundingBox, s.boundingBox) > iouThreshold,
        );
        if (!overlaps) selected.add(candidate);
      }
      kept.addAll(selected);
    }
    return kept;
  }

  double _iou(Rect a, Rect b) {
    final intersection = a.intersect(b);
    if (intersection.width <= 0 || intersection.height <= 0) return 0;
    final interArea = intersection.width * intersection.height;
    final unionArea = a.width * a.height + b.width * b.height - interArea;
    if (unionArea <= 0) return 0;
    return interArea / unionArea;
  }
}
