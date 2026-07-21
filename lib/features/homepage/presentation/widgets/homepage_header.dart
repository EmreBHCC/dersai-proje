import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';

class HomepageHeader extends StatelessWidget {
  const HomepageHeader({
    super.key,
    required this.userFirstName,
    required this.subtitle,
  });

  final String userFirstName;
  final String subtitle;

  String _greetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Günaydın';
    if (hour < 18) return 'İyi günler';
    return 'İyi akşamlar';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greetingPrefix()},',
                style: AppTextStyles.greeting(theme.colorScheme.onSurface),
              ),
              Text(
                userFirstName,
                style: AppTextStyles.greeting(theme.colorScheme.primary),
              ),
              SizedBox(height: 6.h),
              Text(
                subtitle,
                style: AppTextStyles.greetingSubtitle(appColors.textSecondary),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        const _AvatarBadge(),
        SizedBox(width: 8.w),
        const _NotificationButton(),
      ],
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: 20.sp,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: appColors.border),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 20.sp,
            color: theme.colorScheme.onSurface,
          ),
          Positioned(
            top: -1,
            right: -1,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D4D),
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
