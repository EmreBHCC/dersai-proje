import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/widgets/section_header.dart';
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
      icon: Icons.document_scanner_outlined,
      activeIcon: Icons.document_scanner_rounded,
      label: 'Tara',
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
                    TodaysSummaryCard(summary: todaysSummary),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: RecentNotesSection(notes: recentNotes),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: QuickActionsRow(
                  actions: quickActions,
                  onActionTap: (_) {},
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            SliverToBoxAdapter(
              child: CoursesSection(courses: courses),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedNavIndex,
        onItemSelected: (index) {
          setState(() => _selectedNavIndex = index);
        },
      ),
    );
  }
}
