import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/object_detection_service.dart';

final objectDetectionServiceProvider = Provider<ObjectDetectionService>((ref) {
  return ObjectDetectionService();
});
