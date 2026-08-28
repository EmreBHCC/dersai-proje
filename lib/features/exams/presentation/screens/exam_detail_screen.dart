import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../../core/utils/turkish_date_formatter.dart';
import '../../domain/models/exam.dart';
import '../widgets/exam_countdown_timer.dart';
import '../widgets/exam_detail_info_card.dart';
import '../widgets/exam_study_plan_card.dart';

class ExamDetailScreen extends StatelessWidget {
  const ExamDetailScreen({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav Detayı'),
        actions: [
          IconButton(icon: const Icon(Icons.ios_share_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExamHeaderCard(exam: exam),
              SizedBox(height: AppSpacing.lg),
              ExamCountdownTimer(examDate: exam.date),
              SizedBox(height: AppSpacing.lg),
              ExamDetailInfoCard(exam: exam),
              SizedBox(height: AppSpacing.lg),
              ExamStudyPlanCard(
                completed: exam.studyPlanCompleted,
                total: exam.studyPlanTotal,
                onTap: () {},
              ),
              SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Çalışmaya Başla',
                    style: AppTextStyles.buttonLabel(Colors.white),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: appColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Hatırlatıcı Ekle',
                    style: AppTextStyles.buttonLabel(theme.colorScheme.primary),
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

class _ExamHeaderCard extends StatelessWidget {
  const _ExamHeaderCard({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: exam.courseColor, shape: BoxShape.circle),
              ),
              SizedBox(width: 6.w),
              Text(exam.courseCode, style: AppTextStyles.metadata(appColors.textSecondary)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            exam.courseName,
            style: AppTextStyles.sectionTitle(theme.colorScheme.onSurface),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 15.sp, color: appColors.textTertiary),
              SizedBox(width: 6.w),
              Text(
                TurkishDateFormatter.fullDate(exam.date),
                style: AppTextStyles.body(appColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 15.sp, color: appColors.textTertiary),
              SizedBox(width: 6.w),
              Text(exam.timeRange, style: AppTextStyles.body(appColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
