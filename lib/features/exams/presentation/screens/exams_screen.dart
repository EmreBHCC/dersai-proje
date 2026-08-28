import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/exam.dart';
import '../providers/exams_providers.dart';
import '../widgets/exam_card.dart';
import '../widgets/exam_tab_toggle.dart';
import 'exam_detail_screen.dart';

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
    final upcomingExams = ref.watch(upcomingExamsProvider);
    final pastExams = ref.watch(pastExamsProvider);
    final isUpcomingTab = _selectedTab == ExamListTab.upcoming;
    final exams = isUpcomingTab ? upcomingExams : pastExams;

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
              child: exams.isEmpty
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
                    ),
            ),
          ],
        ),
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
