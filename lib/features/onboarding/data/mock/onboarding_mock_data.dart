import 'package:flutter/material.dart';

import '../../domain/models/onboarding_page_data.dart';

abstract final class OnboardingMockData {
  static const List<OnboardingPageData> pages = [
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
}
