import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../courses/domain/models/course_model.dart';
import '../../../courses/presentation/providers/add_course_providers.dart';
import '../../domain/models/exam.dart';
import '../../domain/models/exam_model.dart';
import '../providers/add_exam_providers.dart';
import '../widgets/exam_card.dart';
import '../widgets/exam_tab_toggle.dart';
import 'exam_detail_screen.dart';
import 'add_exam_screen.dart';

Exam _toDisplayExam(
  ExamModel model,
  Map<String, CourseModel> coursesById,
  AppThemeExtension appColors,
) {
  final course = coursesById[model.dersId];
  final colorIndex = model.dersId.hashCode.abs() % appColors.courseColors.length;
  final time =
      '${model.tarihSaat.hour.toString().padLeft(2, '0')}:${model.tarihSaat.minute.toString().padLeft(2, '0')}';
  final konum = model.konum;
  final hoca = course?.dersHocasi;

  return Exam(
    id: model.id ?? '${model.dersId}-${model.tarihSaat.toIso8601String()}',
    courseCode: '',
    courseName: course?.dersAdi ?? 'Ders',
    courseColor: appColors.courseColors[colorIndex],
    date: model.tarihSaat,
    timeRange: time,
    location: (konum != null && konum.isNotEmpty) ? konum : 'Belirtilmedi',
    instructor: (hoca != null && hoca.isNotEmpty) ? hoca : '',
    examType: '',
    weightPercent: 0,
    description: model.aciklama ?? '',
    studyPlanCompleted: 0,
    studyPlanTotal: 0,
  );
}

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({super.key});

  @override
  ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends ConsumerState<ExamsScreen> {
  ExamListTab _selectedTab = ExamListTab.upcoming;

  void _openDetail(Exam exam) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExamDetailScreen(exam: exam)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final examsAsync = ref.watch(myExamsProvider);
    final coursesAsync = ref.watch(myCoursesProvider);
    final isUpcomingTab = _selectedTab == ExamListTab.upcoming;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yaklaşan Sınavlar'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: ExamTabToggle(
                selected: _selectedTab,
                onChanged: (tab) => setState(() => _selectedTab = tab),
              ),
            ),
            Expanded(
              child: examsAsync.when(
                data: (examModels) => coursesAsync.when(
                  data: (courseModels) {
                    final coursesById = <String, CourseModel>{
                      for (final c in courseModels)
                        if (c.id != null) c.id!: c,
                    };
                    final now = DateTime.now();
                    final allExams = examModels
                        .map((m) => _toDisplayExam(m, coursesById, appColors))
                        .toList()
                      ..sort((a, b) => a.date.compareTo(b.date));
                    final upcomingExams =
                        allExams.where((e) => !e.date.isBefore(now)).toList();
                    final pastExams = allExams
                        .where((e) => e.date.isBefore(now))
                        .toList()
                        .reversed
                        .toList();
                    final exams = isUpcomingTab ? upcomingExams : pastExams;

                    return exams.isEmpty
                        ? Center(
                            child: Text(
                              'Gösterilecek sınav bulunamadı.',
                              style: AppTextStyles.body(appColors.textSecondary),
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.screenPadding,
                              0,
                              AppSpacing.screenPadding,
                              AppSpacing.xl,
                            ),
                            children: _buildList(exams, grouped: isUpcomingTab),
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.screenPadding),
                    child: Text(
                      'Sınavlar yüklenemedi: $error',
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
            MaterialPageRoute(builder: (_) => const AddExamScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildList(List<Exam> exams, {required bool grouped}) {
    if (!grouped) {
      return [
        for (final exam in exams) ...[
          ExamCard(exam: exam, onTap: () => _openDetail(exam)),
          SizedBox(height: AppSpacing.sm),
        ],
      ];
    }

    final widgets = <Widget>[];
    String? currentGroup;
    for (final exam in exams) {
      final group = _groupLabel(exam);
      if (group != currentGroup) {
        widgets.add(_GroupLabel(label: group));
        widgets.add(SizedBox(height: AppSpacing.sm));
        currentGroup = group;
      }
      widgets.add(ExamCard(exam: exam, onTap: () => _openDetail(exam)));
      widgets.add(SizedBox(height: AppSpacing.sm));
    }
    return widgets;
  }

  String _groupLabel(Exam exam) {
    final daysRemaining = exam.date.difference(DateTime.now()).inDays;
    if (daysRemaining < 0) return 'Geçmiş';
    if (daysRemaining <= 10) return 'Bu Hafta';
    return 'Gelecek Ay';
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: Text(label, style: AppTextStyles.metadata(appColors.textTertiary)),
    );
  }
}
