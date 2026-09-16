import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../domain/models/note_model.dart';
import '../providers/note_providers.dart';

class VoiceNoteScreen extends ConsumerStatefulWidget {
  const VoiceNoteScreen({super.key});

  @override
  ConsumerState<VoiceNoteScreen> createState() => _VoiceNoteScreenState();
}

class _VoiceNoteScreenState extends ConsumerState<VoiceNoteScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onError: (error) {
        debugPrint('Speech error: $error');
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) return;
    setState(() {
      _isListening = true;
    });
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
      localeId: 'tr_TR',
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Sesli Not')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isListening
                    ? 'Dinleniyor, konuşabilirsin...'
                    : 'Başlamak için mikrofona dokun',
                textAlign: TextAlign.center,
                style: AppTextStyles.body(appColors.textSecondary),
              ),
              SizedBox(height: AppSpacing.xl),
              Center(
                child: GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child: Container(
                    width: 96.w,
                    height: 96.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? Colors.redAccent
                          : theme.colorScheme.primary,
                    ),
                    child: Icon(
                      _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: appColors.border),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _recognizedText.isEmpty
                          ? 'Söylediklerin burada yazı olarak görünecek.'
                          : _recognizedText,
                      style: AppTextStyles.body(
                        _recognizedText.isEmpty
                            ? appColors.textTertiary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _recognizedText.isEmpty
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(noteRepositoryProvider)
                                .saveNote(
                                  NoteModel(
                                    content: _recognizedText,
                                    type: 'voice_note',
                                  ),
                                );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Not kaydedildi.')),
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Kaydedilemedi: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Bitti',
                    style: AppTextStyles.buttonLabel(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
