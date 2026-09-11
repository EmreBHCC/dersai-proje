import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/course.dart';
import '../../domain/models/course_model.dart';
import '../providers/add_course_providers.dart';
import '../widgets/course_list_tile.dart';
import '../widgets/study_tip_card.dart';
import 'course_detail_screen.dart';
import 'add_course_screen.dart';

Course _toDisplayCourse(CourseModel model, AppThemeExtension appColors) {
  final key = model.id ?? model.dersAdi;
  final colorIndex = key.hashCode.abs() % appColors.courseColors.length;
  final hoca = model.dersHocasi;
  final gun = model.gun;
  final derslik = model.derslik;
  final scheduleTime = model.haftalikSaat != null
      ? '${model.haftalikSaat} saat/hafta'
      : 'Belirtilmedi';

  return Course(
    id: model.id ?? key,
    name: model.dersAdi,
    icon: Icons.menu_book_rounded,
    color: appColors.courseColors[colorIndex],
    instructor: (hoca != null && hoca.isNotEmpty) ? hoca : 'Öğretim üyesi eklenmedi',
    noteCount: 0,
    progress: 0,
    credit: model.kredi ?? 0,
    scheduleDay: (gun != null && gun.isNotEmpty) ? gun : 'Belirtilmedi',
    scheduleTime: scheduleTime,
    room: (derslik != null && derslik.isNotEmpty) ? derslik : 'Belirtilmedi',
    description: 'Bu ders için henüz açıklama eklenmedi.',
    materials: const [],
    notes: const [],
  );
}

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  void _openDetail(BuildContext context, Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final coursesAsync = ref.watch(myCoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Derslerim'),
        actions: [
          IconButton(icon: const Icon(Icons.receipt_long_outlined), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: appColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 20.sp,
                            color: appColors.textTertiary,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Ders ara...',
                              style: AppTextStyles.body(appColors.textTertiary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 48.h,
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: appColors.border),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      size: 20.sp,
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: coursesAsync.when(
                data: (models) {
                  final courses =
                      models.map((m) => _toDisplayCourse(m, appColors)).toList();

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.xl,
                    ),
                    itemCount: courses.length + 1,
                    separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index == courses.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: AppSpacing.sm),
                          child: const StudyTipCard(
                            message: 'Notlarını düzenli tut,\nbaşarını bir adım öne taşı!',
                          ),
                        );
                      }
                      final course = courses[index];
                      return CourseListTile(
                        course: course,
                        onTap: () => _openDetail(context, course),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.screenPadding),
                    child: Text(
                      'Dersler yüklenemedi: $error',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(appColors.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
