import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../domain/models/settings_entry.dart';

class ProfileSettingsCard extends StatefulWidget {
  const ProfileSettingsCard({super.key, required this.entries});

  final List<SettingsEntry> entries;

  @override
  State<ProfileSettingsCard> createState() => _ProfileSettingsCardState();
}

class _ProfileSettingsCardState extends State<ProfileSettingsCard> {
  late final Map<String, bool> _toggles = {
    for (final entry in widget.entries)
      if (entry.kind == SettingsEntryKind.toggle) entry.id: entry.initialValue,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: appColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          children: [
            for (var i = 0; i < widget.entries.length; i++) ...[
              if (i > 0)
                Divider(height: 1, thickness: 1, color: appColors.surfaceMuted),
              _SettingsRow(
                entry: widget.entries[i],
                value: _toggles[widget.entries[i].id] ?? false,
                onToggle: (v) =>
                    setState(() => _toggles[widget.entries[i].id] = v),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.entry,
    required this.value,
    required this.onToggle,
  });

  final SettingsEntry entry;
  final bool value;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final accent = entry.highlighted
        ? theme.colorScheme.primary
        : appColors.textSecondary;
    final background = entry.highlighted
        ? theme.colorScheme.primary.withValues(alpha: 0.12)
        : appColors.surfaceMuted;

    final isToggle = entry.kind == SettingsEntryKind.toggle;

    return InkWell(
      onTap: isToggle ? () => onToggle(!value) : () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 6.w,
          vertical: AppSpacing.sm + 5.h,
        ),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(AppRadius.sm - 2.r),
              ),
              child: Icon(entry.icon, size: 14.sp, color: accent),
            ),
            SizedBox(width: AppSpacing.sm + 2.w),
            Expanded(
              child: Text(
                entry.label,
                style: AppTextStyles.metadata(
                  theme.colorScheme.onSurface,
                ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ),
            if (isToggle)
              _MiniSwitch(value: value, onChanged: onToggle)
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 16.sp,
                color: appColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniSwitch extends StatelessWidget {
  const _MiniSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        width: 38.w,
        height: 22.h,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: value ? theme.colorScheme.primary : appColors.border,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
