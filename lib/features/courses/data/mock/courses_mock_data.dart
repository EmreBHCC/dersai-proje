import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/models/course.dart';
import '../../domain/models/course_material.dart';
import '../../domain/models/course_note_preview.dart';

abstract final class CoursesMockData {
  static const List<Course> courses = [
    Course(
      id: 'course-1',
      name: 'Veri Yapıları ve Algoritmalar',
      icon: Icons.integration_instructions_outlined,
      color: AppColors.courseBlue,
      instructor: 'Prof. Dr. Ahmet Yılmaz',
      noteCount: 18,
      progress: 0.72,
      credit: 6,
      scheduleDay: 'Pazartesi',
      scheduleTime: '11:00 - 13:00',
      room: 'A Blok - 203',
      description:
          'Veri yapıları, algoritma analizi ve temel algoritmaların tasarımı '
          've analizi üzerine odaklanır. Uygulamalı örnekler ve problem '
          'çözümü ile desteklenir.',
      materials: [
        CourseMaterial(
          id: 'material-1-1',
          title: 'Dizi (Array) Yapısı',
          fileType: 'PDF',
          date: '12 Mayıs 2025',
        ),
        CourseMaterial(
          id: 'material-1-2',
          title: 'Bağlı Liste (Linked List)',
          fileType: 'PDF',
          date: '19 Mayıs 2025',
        ),
        CourseMaterial(
          id: 'material-1-3',
          title: 'Yığın (Stack)',
          fileType: 'PDF',
          date: '26 Mayıs 2025',
        ),
        CourseMaterial(
          id: 'material-1-4',
          title: 'Kuyruk (Queue)',
          fileType: 'PDF',
          date: '2 Haziran 2025',
        ),
      ],
      notes: [
        CourseNotePreview(
          id: 'note-1-1',
          title: '1. Hafta - Temel Kavramlar',
          accentColor: AppColors.courseBlue,
          previewIcon: Icons.menu_book_outlined,
        ),
        CourseNotePreview(
          id: 'note-1-2',
          title: 'Ağaç Yapıları',
          accentColor: AppColors.courseBlue,
          previewIcon: Icons.account_tree_outlined,
        ),
        CourseNotePreview(
          id: 'note-1-3',
          title: 'Sıralama Algoritmaları',
          accentColor: AppColors.courseBlue,
          previewIcon: Icons.sort_rounded,
        ),
      ],
    ),
    Course(
      id: 'course-2',
      name: 'Organik Kimya',
      icon: Icons.biotech_outlined,
      color: AppColors.courseGreen,
      instructor: 'Doç. Dr. Selin Köse',
      noteCount: 12,
      progress: 0.45,
      credit: 4,
      scheduleDay: 'Çarşamba',
      scheduleTime: '09:00 - 11:00',
      room: 'B Blok - 105',
      description:
          'Organik bileşiklerin yapısı, adlandırılması ve tepkime '
          'mekanizmalarını kapsar. Laboratuvar uygulamalarıyla desteklenir.',
      materials: [
        CourseMaterial(
          id: 'material-2-1',
          title: 'Alkanlar ve İzomerler',
          fileType: 'PDF',
          date: '14 Mayıs 2025',
        ),
        CourseMaterial(
          id: 'material-2-2',
          title: 'Fonksiyonel Gruplar',
          fileType: 'PDF',
          date: '21 Mayıs 2025',
        ),
      ],
      notes: [
        CourseNotePreview(
          id: 'note-2-1',
          title: 'Enzim Kinetiği',
          accentColor: AppColors.courseGreen,
          previewIcon: Icons.science_outlined,
        ),
      ],
    ),
    Course(
      id: 'course-3',
      name: 'Dünya Tarihi',
      icon: Icons.language_outlined,
      color: AppColors.courseOrange,
      instructor: 'Dr. Mehmet Kaya',
      noteCount: 9,
      progress: 0.6,
      credit: 3,
      scheduleDay: 'Salı',
      scheduleTime: '14:00 - 16:00',
      room: 'C Blok - 110',
      description:
          'Yakın çağ dünya tarihini, büyük savaşları ve toplumsal '
          'dönüşümleri ele alır.',
      materials: [
        CourseMaterial(
          id: 'material-3-1',
          title: 'II. Dünya Savaşı Girişi',
          fileType: 'PDF',
          date: '10 Mayıs 2025',
        ),
      ],
      notes: [
        CourseNotePreview(
          id: 'note-3-1',
          title: 'II. Dünya Savaşı Girişi',
          accentColor: AppColors.courseOrange,
          previewIcon: Icons.public_outlined,
        ),
      ],
    ),
    Course(
      id: 'course-4',
      name: 'Lineer Cebir',
      icon: Icons.calculate_outlined,
      color: AppColors.coursePurple,
      instructor: 'Dr. Emre Yıldız',
      noteCount: 15,
      progress: 0.3,
      credit: 5,
      scheduleDay: 'Perşembe',
      scheduleTime: '10:00 - 12:00',
      room: 'A Blok - 108',
      description:
          'Vektör uzayları, matrisler, determinantlar ve lineer '
          'dönüşümler konularını içerir.',
      materials: [
        CourseMaterial(
          id: 'material-4-1',
          title: 'Matrisler ve İşlemler',
          fileType: 'PDF',
          date: '15 Mayıs 2025',
        ),
        CourseMaterial(
          id: 'material-4-2',
          title: 'Özdeğer ve Özvektörler',
          fileType: 'PDF',
          date: '22 Mayıs 2025',
        ),
      ],
      notes: [
        CourseNotePreview(
          id: 'note-4-1',
          title: 'Özdeğer ve Özvektörler',
          accentColor: AppColors.coursePurple,
          previewIcon: Icons.grid_on_outlined,
        ),
      ],
    ),
  ];
}
