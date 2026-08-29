import 'package:flutter/material.dart';

import '../../domain/models/profile_activity.dart';
import '../../domain/models/profile_badge.dart';
import '../../domain/models/profile_stat.dart';
import '../../domain/models/settings_entry.dart';
import '../../domain/models/streak_day.dart';
import '../../domain/models/subject_distribution.dart';
import '../../domain/models/user_profile.dart';

abstract final class ProfileMockData {
  // [fullName] / [initials] are overridden in userProfileProvider from the
  // shared user identity; the values here are placeholders.
  static const UserProfile profile = UserProfile(
    fullName: 'Levent Yılmaz',
    initials: 'LY',
    verifiedLabel: 'DersAI Onaylı Öğrenci',
    stats: [
      ProfileStat(value: '458', label: 'Taranan\nSayfa'),
      ProfileStat(value: '1.230', label: 'AI\nDüzeltmesi'),
      ProfileStat(value: '25', label: 'Sesli Not'),
      ProfileStat(value: '12', label: 'Rozet'),
    ],
  );

  static const WeeklyStreak weeklyStreak = WeeklyStreak(
    title: '7 günlük seri 🔥',
    statusLabel: 'devam ediyor',
    days: [
      StreakDay(label: 'Pt', completed: true),
      StreakDay(label: 'Sa', completed: true),
      StreakDay(label: 'Ça', completed: true),
      StreakDay(label: 'Pe', completed: true),
      StreakDay(label: 'Cu', completed: true),
      StreakDay(label: 'Ct', completed: true),
      StreakDay(label: 'Pz', completed: true, isToday: true),
    ],
  );

  static const List<SubjectDistribution> subjectDistribution = [
    SubjectDistribution(name: 'Matematik', noteCount: 142, ratio: 0.88),
    SubjectDistribution(name: 'Biyoloji', noteCount: 96, ratio: 0.60),
    SubjectDistribution(name: 'Tarih', noteCount: 64, ratio: 0.40),
    SubjectDistribution(name: 'Kimya', noteCount: 41, ratio: 0.25),
  ];

  static const List<ProfileBadge> badges = [
    ProfileBadge(
      icon: Icons.photo_camera_outlined,
      label: 'İlk Tarama',
      unlocked: true,
    ),
    ProfileBadge(
      icon: Icons.auto_awesome_outlined,
      label: '100 Not',
      unlocked: true,
    ),
    ProfileBadge(
      icon: Icons.mic_none_rounded,
      label: 'Sesli Usta',
      unlocked: false,
    ),
  ];

  static const List<ProfileActivity> recentActivity = [
    ProfileActivity(
      icon: Icons.photo_camera_outlined,
      title: '"Türev Kuralları" tarandı',
      timeLabel: 'Bugün, 14:20',
      tone: ProfileActivityTone.primary,
    ),
    ProfileActivity(
      icon: Icons.mic_none_rounded,
      title: 'Biyoloji için sesli not eklendi',
      timeLabel: 'Dün, 19:04',
      tone: ProfileActivityTone.neutral,
    ),
    ProfileActivity(
      icon: Icons.check_rounded,
      title: '"Mol Kavramı" AI ile düzeltildi',
      timeLabel: '3 gün önce',
      tone: ProfileActivityTone.success,
    ),
  ];

  static const List<SettingsEntry> settings = [
    SettingsEntry(
      id: 'notifications',
      icon: Icons.notifications_none_rounded,
      label: 'Bildirimler',
      kind: SettingsEntryKind.toggle,
      initialValue: true,
    ),
    SettingsEntry(
      id: 'dark-mode',
      icon: Icons.dark_mode_outlined,
      label: 'Karanlık Mod',
      kind: SettingsEntryKind.toggle,
      highlighted: false,
    ),
    SettingsEntry(
      id: 'app-security',
      icon: Icons.shield_outlined,
      label: 'Uygulama Güvenliği',
      kind: SettingsEntryKind.navigation,
    ),
    SettingsEntry(
      id: 'account',
      icon: Icons.person_outline_rounded,
      label: 'Hesap Bilgileri',
      kind: SettingsEntryKind.navigation,
      highlighted: false,
    ),
  ];
}
