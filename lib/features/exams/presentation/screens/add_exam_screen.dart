import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;
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
          sinavAdi: _sinavAdiController.text.trim(),
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
    final coursesAsync = ref.watch(myCoursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Sınav Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              coursesAsync.when(
                data: (courses) {
                  return DropdownButtonFormField<CourseModel>(
                    initialValue: _selectedCourse,
                    decoration: const InputDecoration(labelText: 'Ders'),
                    items: courses
                        .map(
                          (course) => DropdownMenuItem(
                            value: course,
                            child: Text(course.dersAdi),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCourse = value),
                    validator: (value) =>
                        value == null ? 'Ders seçimi zorunlu' : null,
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Dersler yüklenemedi: $e'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sinavAdiController,
                decoration: const InputDecoration(labelText: 'Sınav Adı'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Sınav adı zorunlu'
                        : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Tarih ve Saat'),
                  child: Text(
                    _selectedDateTime == null
                        ? 'Seçilmedi'
                        : '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} '
                          '${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sureController,
                decoration: const InputDecoration(labelText: 'Süre (dakika)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _konumController,
                decoration: const InputDecoration(labelText: 'Konum'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aciklamaController,
                decoration:
                    const InputDecoration(labelText: 'Açıklama (Opsiyonel)'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hatirlatmaController,
                decoration: const InputDecoration(
                  labelText: 'Hatırlatma (dakika önce)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}