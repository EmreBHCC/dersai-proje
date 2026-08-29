import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../homepage/presentation/providers/homepage_providers.dart';
import '../../data/mock/profile_mock_data.dart';
import '../../domain/models/profile_activity.dart';
import '../../domain/models/profile_badge.dart';
import '../../domain/models/settings_entry.dart';
import '../../domain/models/streak_day.dart';
import '../../domain/models/subject_distribution.dart';
import '../../domain/models/user_profile.dart';

final userProfileProvider = Provider<UserProfile>((ref) {
  final fullName = ref.watch(userFullNameProvider);
  final base = ProfileMockData.profile;
  return UserProfile(
    fullName: fullName,
    initials: _initialsFor(fullName),
    verifiedLabel: base.verifiedLabel,
    stats: base.stats,
  );
});

String _initialsFor(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    final word = parts.first;
    return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

final weeklyStreakProvider = Provider<WeeklyStreak>((ref) {
  return ProfileMockData.weeklyStreak;
});

final subjectDistributionProvider = Provider<List<SubjectDistribution>>((ref) {
  return ProfileMockData.subjectDistribution;
});

final profileBadgesProvider = Provider<List<ProfileBadge>>((ref) {
  return ProfileMockData.badges;
});

final recentActivityProvider = Provider<List<ProfileActivity>>((ref) {
  return ProfileMockData.recentActivity;
});

final settingsEntriesProvider = Provider<List<SettingsEntry>>((ref) {
  return ProfileMockData.settings;
});
