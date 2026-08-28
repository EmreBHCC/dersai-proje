import '../../../../app/theme/app_colors.dart';
import '../../domain/models/exam.dart';

abstract final class ExamsMockData {
  static final DateTime _now = DateTime.now();

  static DateTime _at(int daysFromNow, int hour, int minute) {
    final target = _now.add(Duration(days: daysFromNow));
    return DateTime(target.year, target.month, target.day, hour, minute);
  }

  static final List<Exam> upcoming = [
    Exam(
      id: 'exam-1',
      courseCode: 'CS 201',
      courseName: 'Veri Yapıları',
      courseColor: AppColors.courseBlue,
      date: _at(3, 10, 0),
      timeRange: '10:00 – 12:00',
      location: 'A Blok - 203',
      instructor: 'Prof. Dr. Ahmet Yılmaz',
      examType: 'Vize',
      weightPercent: 30,
      description: 'Hesap makinesi kullanılabilir.',
      studyPlanCompleted: 5,
      studyPlanTotal: 10,
    ),
    Exam(
      id: 'exam-2',
      courseCode: 'BUS 105',
      courseName: 'İşletme Yönetimi',
      courseColor: AppColors.coursePurple,
      date: _at(6, 14, 30),
      timeRange: '14:30 – 16:30',
      location: 'B Blok - 104',
      instructor: 'Dr. Öğr. Üyesi Elif Kaya',
      examType: 'Vize',
      weightPercent: 25,
      description: 'Kitapsız ve notsuz bir sınavdır.',
      studyPlanCompleted: 2,
      studyPlanTotal: 8,
    ),
    Exam(
      id: 'exam-3',
      courseCode: 'MATH 210',
      courseName: 'Olasılık ve İstatistik',
      courseColor: AppColors.courseOrange,
      date: _at(9, 9, 0),
      timeRange: '09:00 – 11:00',
      location: 'A Blok - 101',
      instructor: 'Prof. Dr. Murat Demir',
      examType: 'Vize',
      weightPercent: 30,
      description: 'Formül kağıdı sınav ile birlikte dağıtılacaktır.',
      studyPlanCompleted: 3,
      studyPlanTotal: 12,
    ),
    Exam(
      id: 'exam-4',
      courseCode: 'CS 305',
      courseName: 'Veritabanı Sistemleri',
      courseColor: AppColors.courseGreen,
      date: _at(15, 13, 0),
      timeRange: '13:00 – 15:00',
      location: 'A Blok - 205',
      instructor: 'Dr. Öğr. Üyesi Zeynep Arslan',
      examType: 'Final',
      weightPercent: 40,
      description: 'Dönem boyunca işlenen tüm konulardan sorumlusunuz.',
      studyPlanCompleted: 0,
      studyPlanTotal: 10,
    ),
    Exam(
      id: 'exam-5',
      courseCode: 'CS 402',
      courseName: 'Yapay Zeka',
      courseColor: AppColors.courseTeal,
      date: _at(20, 11, 0),
      timeRange: '11:00 – 13:00',
      location: 'B Blok - 201',
      instructor: 'Prof. Dr. Can Öztürk',
      examType: 'Final',
      weightPercent: 40,
      description: 'Uygulamalı sorular içerir, laptop gerekmez.',
      studyPlanCompleted: 1,
      studyPlanTotal: 10,
    ),
  ];

  static final List<Exam> past = [
    Exam(
      id: 'exam-past-1',
      courseCode: 'PHY 101',
      courseName: 'Fizik',
      courseColor: AppColors.coursePink,
      date: _at(-12, 10, 0),
      timeRange: '10:00 – 12:00',
      location: 'A Blok - 110',
      instructor: 'Dr. Öğr. Üyesi Selin Yıldız',
      examType: 'Vize',
      weightPercent: 30,
      description: 'Hesap makinesi kullanılabilir.',
      studyPlanCompleted: 10,
      studyPlanTotal: 10,
    ),
    Exam(
      id: 'exam-past-2',
      courseCode: 'CS 201',
      courseName: 'Veri Yapıları',
      courseColor: AppColors.courseBlue,
      date: _at(-30, 10, 0),
      timeRange: '10:00 – 12:00',
      location: 'A Blok - 203',
      instructor: 'Prof. Dr. Ahmet Yılmaz',
      examType: 'Quiz',
      weightPercent: 10,
      description: 'İlk 3 hafta konularını kapsar.',
      studyPlanCompleted: 6,
      studyPlanTotal: 6,
    ),
  ];
}
