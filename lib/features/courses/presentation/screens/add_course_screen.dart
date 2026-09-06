import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../app/theme/app_spacing.dart';
import '../../../auth/presentation/widgets/auth_field_label.dart';
import '../../../auth/presentation/widgets/auth_primary_button.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../domain/models/course_model.dart';
import '../providers/add_course_providers.dart';
class AddCourseScreen extends ConsumerStatefulWidget {
  const AddCourseScreen({super.key});

  @override
  ConsumerState<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends ConsumerState<AddCourseScreen> {
 
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
    if (_isSaving) return;

    final dersAdi = _dersAdiController.text.trim();
    if (dersAdi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ders adı zorunlu')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(courseRepositoryProvider);
      await repository.addCourse(
        CourseModel(
          userId: '',
          dersAdi: dersAdi,
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
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: ListView(
          children: [
            const AuthFieldLabel('Ders Adı'),
            AuthTextField(
              controller: _dersAdiController,
              hintText: 'Örn. Veri Yapıları',
              icon: Icons.menu_book_outlined,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Ders Hocası'),
            AuthTextField(
              controller: _dersHocasiController,
              hintText: 'Örn. Prof. Dr. Ayşe Yılmaz',
              icon: Icons.person_outline_rounded,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Kredi'),
            AuthTextField(
              controller: _krediController,
              hintText: 'Örn. 4',
              icon: Icons.star_outline_rounded,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.md),
            const AuthFieldLabel('Haftalık Ders Saati'),
            AuthTextField(
              controller: _haftalikSaatController,
              hintText: 'Örn. 3',
              icon: Icons.schedule_outlined,
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
 