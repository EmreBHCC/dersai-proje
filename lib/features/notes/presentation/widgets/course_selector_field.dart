import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../courses/presentation/providers/add_course_providers.dart';

class CourseSelectorField extends ConsumerWidget {
  const CourseSelectorField({
    super.key,
    required this.selectedCourseId,
    required this.onChanged,
  });

  final String? selectedCourseId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final coursesAsync = ref.watch(myCoursesProvider);

    return coursesAsync.when(
      data: (courses) {
        final validCourses = courses.where((c) => c.id != null).toList();

        if (validCourses.isEmpty) {
          return _FieldContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                'Not eklemeden önce bir ders eklemelisin.',
                style: AppTextStyles.body(appColors.textSecondary),
              ),
            ),
          );
        }

        return _FieldContainer(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                'Hangi derse ait?',
                style: AppTextStyles.body(appColors.textSecondary),
              ),
              style: AppTextStyles.body(theme.colorScheme.onSurface),
              value: selectedCourseId,
              items: [
                for (final course in validCourses)
                  DropdownMenuItem<String>(
                    value: course.id,
                    child: Text(course.dersAdi),
                  ),
              ],
              onChanged: onChanged,
            ),
          ),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text('Dersler yüklenemedi: $error'),
    );
  }
}

class _FieldContainer extends StatelessWidget {
  const _FieldContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.appColors.border),
      ),
      child: child,
    );
  }
}
