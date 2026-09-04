import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../courses/presentation/providers/courses_providers.dart';
import '../../../courses/presentation/screens/course_detail_screen.dart';
import '../../../courses/presentation/screens/courses_screen.dart';
import '../../../detection/presentation/screens/image_source_screen.dart';
import '../../../exams/presentation/providers/exams_providers.dart';
import '../../../exams/presentation/screens/exam_detail_screen.dart';
import '../../../exams/presentation/screens/exams_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../providers/homepage_providers.dart';
import '../widgets/courses_section.dart';
import '../widgets/homepage_header.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/recent_notes_section.dart';
import '../widgets/todays_summary_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedNavIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final userFirstName = ref.watch(userFirstNameProvider);
    final todaysSummary = ref.watch(todaysSummaryProvider);
    final quickActions = ref.watch(quickActionsProvider);
    final recentNotes = ref.watch(recentNotesProvider);
    final courses = ref.watch(coursesProvider);
    final nearestExam = ref.watch(upcomingExamsProvider).first;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomepageHeader(
                      userFirstName: userFirstName,
                      subtitle: 'Bugün 3 dersin var.',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Bugünün Özeti'),
                    SizedBox(height: AppSpacing.md),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ExamDetailScreen(exam: nearestExam),
                          ),
                        );
                      },
                      child: TodaysSummaryCard(summary: todaysSummary),
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: RecentNotesSection(notes: recentNotes)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: QuickActionsRow(
                  actions: quickActions,
                  onActionTap: (action) {
                    if (action.id == 'scan') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ImageSourceScreen(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(
              child: CoursesSection(
                courses: courses,
                onCourseTap: (course) {
                  final matched = ref
                      .read(allCoursesProvider)
                      .firstWhere((c) => c.id == course.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CourseDetailScreen(course: matched),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedNavIndex,
        onItemSelected: (index) {
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
            return;
          }
          if (index == 3) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
            return;
          }
          setState(() => _selectedNavIndex = index);
        },
      ),
    );
  }
}
