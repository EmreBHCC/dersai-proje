import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../auth/presentation/widgets/auth_field_label.dart';
import '../../../auth/presentation/widgets/auth_primary_button.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../courses/domain/models/course_model.dart';
import '../../../courses/presentation/providers/add_course_providers.dart';
import '../../domain/models/exam_model.dart';
import '../providers/add_exam_providers.dart';
class AddExamScreen extends ConsumerStatefulWidget {
  const AddExamScreen({super.key});

  @override
  ConsumerState<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends ConsumerState<AddExamScreen> {
  
  final _sinavAdiController = TextEditingController();
  final _sureController = TextEditingController();
  final _konumController = TextEditingController();
  final _aciklamaController = TextEditingController();
  final _hatirlatmaController = TextEditingController();

  CourseModel? _selectedCourse;
  DateTime? _selectedDateTime;
  bool _isSaving = false;

  @override
  void dispose() {
    _sinavAdiController.dispose();
    _sureController.dispose();
    _konumController.dispose();
    _aciklamaController.dispose();
    _hatirlatmaController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

   Future<void> _save() async {
    if (_isSaving) return;

    final sinavAdi = _sinavAdiController.text.trim();
    if (sinavAdi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sınav adı zorunlu')),
      );
      return;
    }
    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir ders seç')),
      );
      return;
    }
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tarih ve saat seç')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(examRepositoryProvider);
      await repository.addExam(
        ExamModel(
          userId: '',
          dersId: _selectedCourse!.id!,
          sinavAdi: sinavAdi,
          tarihSaat: _selectedDateTime!,
          sureDakika: int.tryParse(_sureController.text.trim()),
          konum: _konumController.text.trim(),
          aciklama: _aciklamaController.text.trim(),
          hatirlatmaDakika: int.tryParse(_hatirlatmaController.text.trim()),
        ),
      );

      ref.invalidate(myExamsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sınav eklendi')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

    @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final coursesAsync = ref.watch(myCoursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Sınav Ekle')),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: ListView(
          children: [
            const AuthFieldLabel('Ders'),
            coursesAsync.when(
              data: (courses) => Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                  border: Border.all(color: appColors.border, width: 0.5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CourseModel>(
                    isExpanded: true,
                    value: _selectedCourse,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: appColors.textTertiary),
                    hint: Text('Ders seç', style: TextStyle(fontSize: 14.sp, color: appColors.textTertiary)),
                    items: courses
                        .map(
                          (course) => DropdownMenuItem(
                            value: course,
                            child: Text(course.dersAdi, style: TextStyle(fontSize: 14.sp)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedCourse = value),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text('Dersler yüklenemedi: $e', style: AppTextStyles.body(appColors.textSecondary)),
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Sınav Adı'),
            AuthTextField(
              controller: _sinavAdiController,
              hintText: 'Örn. Vize Sınavı',
              icon: Icons.edit_note_rounded,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Tarih ve Saat'),
            InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(AppRadius.sm + 2),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                  border: Border.all(color: appColors.border, width: 0.5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  children: [
                    Icon(Icons.event_outlined, size: 16.sp, color: appColors.textTertiary),
                    SizedBox(width: 8.w),
                    Text(
                      _selectedDateTime == null
                          ? 'Seçilmedi'
                          : '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} '
                            '${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 14.sp, color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Süre (dakika)'),
            AuthTextField(
              controller: _sureController,
              hintText: 'Örn. 60',
              icon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Konum'),
            AuthTextField(
              controller: _konumController,
              hintText: 'Örn. B Blok 204',
              icon: Icons.location_on_outlined,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Açıklama (Opsiyonel)'),
            AuthTextField(
              controller: _aciklamaController,
              hintText: 'Ek not ekle',
              icon: Icons.notes_rounded,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Hatırlatma (dakika önce)'),
            AuthTextField(
              controller: _hatirlatmaController,
              hintText: 'Örn. 30',
              icon: Icons.notifications_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.lg),
            AuthPrimaryButton(
              label: _isSaving ? 'Kaydediliyor...' : 'Kaydet',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
