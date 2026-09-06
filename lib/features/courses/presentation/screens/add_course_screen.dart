import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/course_model.dart';
import '../providers/add_course_providers.dart';

class AddCourseScreen extends ConsumerStatefulWidget {
  const AddCourseScreen({super.key});

  @override
  ConsumerState<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends ConsumerState<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dersAdiController = TextEditingController();
  final _dersHocasiController = TextEditingController();
  final _krediController = TextEditingController();
  final _haftalikSaatController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _dersAdiController.dispose();
    _dersHocasiController.dispose();
    _krediController.dispose();
    _haftalikSaatController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(courseRepositoryProvider);
      await repository.addCourse(
        CourseModel(
          userId: '',
          dersAdi: _dersAdiController.text.trim(),
          dersHocasi: _dersHocasiController.text.trim(),
          kredi: int.tryParse(_krediController.text.trim()),
          haftalikSaat: int.tryParse(_haftalikSaatController.text.trim()),
        ),
      );

      ref.invalidate(myCoursesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ders eklendi')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Ders Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
            
             TextFormField(
                controller: _dersAdiController,
                decoration: const InputDecoration(labelText: 'Ders Adı'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Ders adı zorunlu'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dersHocasiController,
                decoration: const InputDecoration(labelText: 'Ders Hocası'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _krediController,
                decoration: const InputDecoration(labelText: 'Kredi'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _haftalikSaatController,
                decoration:
                    const InputDecoration(labelText: 'Haftalık Ders Saati'),
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