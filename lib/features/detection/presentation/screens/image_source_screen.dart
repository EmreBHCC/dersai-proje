import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../widgets/image_source_button.dart';
import 'detection_result_screen.dart';

class ImageSourceScreen extends StatelessWidget {
  const ImageSourceScreen({super.key});

  Future<void> _pickAndDetect(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked;
    try {
      picked = await picker.pickImage(source: source, maxWidth: 1920);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğrafa erişilemedi.')),
      );
      return;
    }
    if (picked == null || !context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetectionResultScreen(imageFile: File(picked!.path)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Fotoğraf Tara')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sorularını taramak için bir fotoğraf seç',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
              ),
              SizedBox(height: AppSpacing.xl),
              ImageSourceButton(
                icon: Icons.camera_alt_rounded,
                label: 'Kameradan Çek',
                onTap: () => _pickAndDetect(context, ImageSource.camera),
              ),
              SizedBox(height: AppSpacing.md),
              ImageSourceButton(
                icon: Icons.photo_library_outlined,
                label: 'Galeriden Seç',
                onTap: () => _pickAndDetect(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
