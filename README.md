# DersAI 📚🤖

DersAI, öğrencilerin ders süresince çektikleri fotoğrafları dijital ortama aktararak, okunabilir hale getiren akıllı bir mobil uygulamadır. Kullanıcılar, bu fotoğrafları kategorilere ayırabilir, yazı ve görselleri ayrıştırabilir, eksik ya da hatalı OCR verilerini yapay zeka destekli API ile düzenleyebilir ve isterlerse sesi kullanarak not oluşturabilirler. Tüm bu işlevler, ders sonrası tekrar ve verimlilik için optimize edilmiştir.

DersAI is a smart mobile application that transforms class-related photos taken by students into clean, readable digital notes. Users can categorize their notes, separate text from images using classification, and improve incorrectly read text via AI-powered APIs. It also supports voice input for note creation. All features aim to enhance learning efficiency and post-class review.

## Proje Yapısı

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_radius.dart
│       ├── app_spacing.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       └── app_theme_extension.dart
│
├── core/
│   └── widgets/
│       ├── app_bottom_navigation_bar.dart
│       └── section_header.dart
│
└── features/
    └── dashboard/
        ├── data/
        │   └── mock/
        │       └── dashboard_mock_data.dart
        ├── domain/
        │   └── models/
        │       ├── course.dart
        │       ├── quick_action.dart
        │       ├── recent_note.dart
        │       └── todays_summary.dart
        └── presentation/
            ├── providers/
            │   └── dashboard_providers.dart
            ├── screens/
            │   └── home_screen.dart
            └── widgets/
                ├── course_card.dart
                ├── courses_section.dart
                ├── dashboard_header.dart
                ├── quick_action_button.dart
                ├── quick_actions_row.dart
                ├── recent_note_card.dart
                ├── recent_notes_section.dart
                ├── scan_action_button.dart
                └── todays_summary_card.dart
```

## Kullanılan Teknolojiler

- Flutter
- Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- `flutter_screenutil` — responsive ölçeklendirme
- `google_fonts` — tipografi
