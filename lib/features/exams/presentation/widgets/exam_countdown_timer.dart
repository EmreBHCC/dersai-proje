import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class ExamCountdownTimer extends StatefulWidget {
  const ExamCountdownTimer({super.key, required this.examDate});

  final DateTime examDate;

  @override
  State<ExamCountdownTimer> createState() => _ExamCountdownTimerState();
}

class _ExamCountdownTimerState extends State<ExamCountdownTimer> {
  late Duration _remaining;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remaining = _computeRemaining());
    });
  }

  Duration _computeRemaining() {
    final diff = widget.examDate.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sınava Kalan Süre',
            style: AppTextStyles.metadata(appColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CountdownUnit(value: days, label: 'Gün'),
              const _CountdownSeparator(),
              _CountdownUnit(value: hours, label: 'Saat'),
              const _CountdownSeparator(),
              _CountdownUnit(value: minutes, label: 'Dakika'),
              const _CountdownSeparator(),
              _CountdownUnit(value: seconds, label: 'Saniye'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  const _CountdownUnit({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: AppTextStyles.statValue(theme.colorScheme.primary),
        ),
        SizedBox(height: 2.h),
        Text(label, style: AppTextStyles.metadata(appColors.textTertiary)),
      ],
    );
  }
}

class _CountdownSeparator extends StatelessWidget {
  const _CountdownSeparator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        ':',
        style: AppTextStyles.statValue(Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
