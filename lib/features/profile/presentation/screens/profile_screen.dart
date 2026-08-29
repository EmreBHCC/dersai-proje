import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../auth/presentation/providers/user_session_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../courses/presentation/screens/courses_screen.dart';
import '../../../exams/presentation/screens/exams_screen.dart';
import '../providers/profile_providers.dart';
import '../widgets/premium_banner.dart';
import '../widgets/profile_badges_row.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_section_label.dart';
import '../widgets/profile_settings_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/subject_distribution_card.dart';
import '../widgets/weekly_streak_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const int _navIndex = 3;

  static const List<AppBottomNavItem> _navItems = [
    AppBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Anasayfa',
    ),
    AppBottomNavItem(
      icon: Icons.event_note_outlined,
      activeIcon: Icons.event_note_rounded,
      label: 'Sınavlarım',
    ),
    AppBottomNavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      label: 'Dersler',
    ),
    AppBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  void _onNavSelected(BuildContext context, int index) {
    if (index == _navIndex) return;
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ExamsScreen()));
      return;
    }
    if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CoursesScreen()));
    }
  }

  void _logout(BuildContext context, WidgetRef ref) {
    ref.read(userSessionProvider.notifier).signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final weeklyStreak = ref.watch(weeklyStreakProvider);
    final subjects = ref.watch(subjectDistributionProvider);
    final badges = ref.watch(profileBadgesProvider);
    final activities = ref.watch(recentActivityProvider);
    final settings = ref.watch(settingsEntriesProvider);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Column(
        children: [
          ProfileHeader(profile: profile),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.lg,
                    AppSpacing.screenPadding,
                    AppSpacing.xl,
                  ),
                  children: [
                    ProfileSectionLabel(
                      title: 'Bu Hafta',
                      actionLabel: 'Geçmiş →',
                      onActionTap: () {},
                    ),
                    SizedBox(height: AppSpacing.sm + 2.h),
                    WeeklyStreakCard(streak: weeklyStreak),
                    SizedBox(height: AppSpacing.lg),
                    const ProfileSectionLabel(title: 'Derslere Göre Dağılım'),
                    SizedBox(height: AppSpacing.sm + 2.h),
                    SubjectDistributionCard(subjects: subjects),
                    SizedBox(height: AppSpacing.lg),
                    ProfileSectionLabel(
                      title: 'Rozetler',
                      actionLabel: 'Tümü →',
                      onActionTap: () {},
                    ),
                    SizedBox(height: AppSpacing.sm + 2.h),
                    ProfileBadgesRow(badges: badges),
                    SizedBox(height: AppSpacing.lg),
                    const ProfileSectionLabel(title: 'Son Etkinlik'),
                    SizedBox(height: AppSpacing.sm + 2.h),
                    RecentActivityCard(activities: activities),
                    SizedBox(height: AppSpacing.lg),
                    const ProfileSectionLabel(title: 'Ayarlar'),
                    SizedBox(height: AppSpacing.sm + 2.h),
                    ProfileSettingsCard(entries: settings),
                    SizedBox(height: AppSpacing.md),
                    PremiumBanner(onTap: () {}),
                    SizedBox(height: AppSpacing.md),
                    ProfileLogoutButton(onTap: () => _logout(context, ref)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        items: _navItems,
        currentIndex: _navIndex,
        onItemSelected: (index) => _onNavSelected(context, index),
      ),
    );
  }
}
