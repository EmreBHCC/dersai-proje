import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/generated_note.dart';
import '../../domain/models/note_generation_request.dart';
import '../../domain/models/note_model.dart';
import '../providers/note_generation_providers.dart';
import '../providers/note_providers.dart';
import '../widgets/course_selector_field.dart';
import '../widgets/generated_note_content.dart';

class GeneratedNoteScreen extends ConsumerStatefulWidget {
  const GeneratedNoteScreen({
    super.key,
    required this.request,
    this.courseId,
  });

  final NoteGenerationRequest request;
  final String? courseId;

  @override
  ConsumerState<GeneratedNoteScreen> createState() =>
      _GeneratedNoteScreenState();
}

class _GeneratedNoteScreenState extends ConsumerState<GeneratedNoteScreen> {
  String? _selectedCourseId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCourseId = widget.courseId;
    Future.microtask(_generate);
  }

  Future<void> _generate() {
    return ref
        .read(noteGenerationControllerProvider.notifier)
        .generate(widget.request);
  }

  Future<void> _save(GeneratedNote note) async {
    final courseId = _selectedCourseId;
    if (courseId == null) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(noteRepositoryProvider)
          .saveNote(
            NoteModel(
              content: note.toMarkdown(),
              type: 'scan_note',
              subjectId: courseId,
            ),
          );
      ref.invalidate(courseNotesProvider(courseId));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not kaydedildi.')));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kaydedilemedi: $error')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final generation = ref.watch(noteGenerationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Taranan Not')),
      body: SafeArea(
        child: generation.when(
          loading: () => const _GenerationProgressView(),
          error: (error, _) =>
              _GenerationErrorView(message: '$error', onRetry: _generate),
          data: (note) => note == null
              ? const _GenerationProgressView()
              : _GeneratedNoteBody(
                  note: note,
                  selectedCourseId: _selectedCourseId,
                  isSaving: _isSaving,
                  showCourseSelector: widget.courseId == null,
                  onCourseChanged: (value) =>
                      setState(() => _selectedCourseId = value),
                  onSave: () => _save(note),
                ),
        ),
      ),
    );
  }
}

class _GeneratedNoteBody extends StatelessWidget {
  const _GeneratedNoteBody({
    required this.note,
    required this.selectedCourseId,
    required this.isSaving,
    required this.showCourseSelector,
    required this.onCourseChanged,
    required this.onSave,
  });

  final GeneratedNote note;
  final String? selectedCourseId;
  final bool isSaving;
  final bool showCourseSelector;
  final ValueChanged<String?> onCourseChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: GeneratedNoteContent(note: note),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showCourseSelector) ...[
                CourseSelectorField(
                  selectedCourseId: selectedCourseId,
                  onChanged: onCourseChanged,
                ),
                SizedBox(height: AppSpacing.sm),
              ],
              SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: selectedCourseId == null || isSaving
                      ? null
                      : onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Notu Kaydet',
                          style: AppTextStyles.buttonLabel(Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GenerationProgressView extends StatelessWidget {
  const _GenerationProgressView();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text(
            'Notun hazırlanıyor...',
            style: AppTextStyles.body(appColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _GenerationErrorView extends StatelessWidget {
  const _GenerationErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(appColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.md),
            OutlinedButton(onPressed: onRetry, child: const Text('Tekrar Dene')),
          ],
        ),
      ),
    );
  }
}
