import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/onboarding_mock_data.dart';
import '../../domain/models/onboarding_page_data.dart';

final onboardingPagesProvider = Provider<List<OnboardingPageData>>((ref) {
  return OnboardingMockData.pages;
});
