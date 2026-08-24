import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../notes/presentation/screens/processed_text_screen.dart';
import '../../domain/models/detected_object.dart';
import '../providers/detection_providers.dart';
import '../widgets/detection_painter.dart';

class DetectionResultScreen extends ConsumerStatefulWidget {
  const DetectionResultScreen({super.key, required this.imageFile});

  final File imageFile;

  @override
  ConsumerState<DetectionResultScreen> createState() =>
      _DetectionResultScreenState();
}

class _DetectionResultScreenState extends ConsumerState<DetectionResultScreen> {
  ui.Image? _image;
  List<DetectedObject>? _detections;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _runDetection();
  }

  Future<void> _runDetection() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      final service = ref.read(objectDetectionServiceProvider);
      final detections = await service.detect(widget.imageFile);

      if (!mounted) return;
      setState(() {
        _image = frame.image;
        _detections = detections;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tespit Sonucu')),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            'Tahmin yapılırken bir hata oluştu:\n$_error',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(appColors.textSecondary),
          ),
        ),
      );
    }

    final image = _image;
    final detections = _detections;
    if (image == null || detections == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: image.width / image.height,
              child: CustomPaint(
                painter: DetectionPainter(image: image, detections: detections),
              ),
            ),
          ),
        ),
        Expanded(
          child: detections.isEmpty
              ? Center(
                  child: Text(
                    'Görselde herhangi bir nesne tespit edilemedi.',
                    style: AppTextStyles.body(appColors.textSecondary),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  itemCount: detections.length,
                  separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final detection = detections[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: detectionColorForClass(detection.classId),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              detection.className,
                              style: AppTextStyles.cardTitle(
                                theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Text(
                            '${(detection.confidence * 100).toStringAsFixed(1)}%',
                            style: AppTextStyles.metadata(appColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.md,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProcessedTextScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'İşlenmiş Metni Kaydet',
                    style: AppTextStyles.buttonLabel(Colors.white),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
