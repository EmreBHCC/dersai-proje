import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../homepage/presentation/screens/home_screen.dart';
import '../../domain/models/onboarding_page_data.dart';
import '../widgets/onboarding_dot_indicator.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      icon: Icons.menu_book_rounded,
      title: 'Derslerini Tek Yerden Takip Et',
      description:
          'Tüm derslerini, notlarını ve ödevlerini tek bir uygulamada düzenli tut.',
    ),
    OnboardingPageData(
      icon: Icons.document_scanner_rounded,
      title: 'Notlarını Saniyeler İçinde Tara',
      description:
          'Kamerayla tarat, Dersai senin için düzenlesin ve özetlesin.',
    ),
    OnboardingPageData(
      icon: Icons.auto_awesome_rounded,
      title: 'Yapay Zeka ile Daha Hızlı Öğren',
      description:
          'Konu özetleri ve akıllı hatırlatmalarla çalışma verimini artır.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _onNextPressed() {
    if (_currentIndex == _pages.length - 1) {
      _goToHome();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isLastPage = _currentIndex == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: TextButton(
                  onPressed: isLastPage ? null : _goToHome,
                  child: Text(
                    'Geç',
                    style: AppTextStyles.buttonLabel(
                      isLastPage
                          ? Colors.transparent
                          : appColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return OnboardingSlide(data: _pages[index]);
                },
              ),
            ),
            OnboardingDotIndicator(
              pageCount: _pages.length,
              currentIndex: _currentIndex,
            ),
            SizedBox(height: AppSpacing.xl),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLastPage ? 'Başla' : 'Devam Et',
                    style: AppTextStyles.buttonLabel(Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
