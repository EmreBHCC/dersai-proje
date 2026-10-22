import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../homepage/presentation/providers/homepage_providers.dart';
import '../../data/mock/profile_mock_data.dart';
import '../../domain/models/profile_activity.dart';
import '../../domain/models/profile_badge.dart';
import '../../domain/models/settings_entry.dart';
import '../../domain/models/streak_day.dart';
import '../../domain/models/subject_distribution.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/profile_stat.dart';

SupabaseClient get _client => SupabaseService.client;

String? get _userId => _client.auth.currentUser?.id;

final userProfileProvider = FutureProvider.autoDispose<UserProfile>((ref) async {
  final fullName = ref.watch(userFullNameProvider);
  final base = ProfileMockData.profile;
  final userId = _userId;

  if (userId == null) {
    return UserProfile(
      fullName: fullName,
      initials: _initialsFor(fullName),
      verifiedLabel: base.verifiedLabel,
      stats: base.stats,
    );
  }

  final allNotes = await _client
      .from('notes')
      .select('type')
      .eq('user_id', userId);

  final notesList = allNotes as List;
  final scannedCount =
      notesList.where((n) => n['type'] == 'scanned_page').length;
  final voiceCount =
      notesList.where((n) => n['type'] == 'voice_note').length;
  final aiCount =
      notesList.where((n) => n['type'] == 'ai_correction').length;

  final userBadges = await _client
      .from('user_badges')
      .select('badge_id')
      .eq('user_id', userId);
  final badgesCount = (userBadges as List).length;

  final stats = [
    ProfileStat(value: '$scannedCount', label: 'Taranan\nSayfa'),
    ProfileStat(value: '$aiCount', label: 'AI\nDüzeltmesi'),
    ProfileStat(value: '$voiceCount', label: 'Sesli Not'),
    ProfileStat(value: '$badgesCount', label: 'Rozet'),
  ];

  return UserProfile(
    fullName: fullName,
    initials: _initialsFor(fullName),
    verifiedLabel: base.verifiedLabel,
    stats: stats,
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

final weeklyStreakProvider = FutureProvider.autoDispose<WeeklyStreak>((ref) async {
  final userId = _userId;
  if (userId == null) return ProfileMockData.weeklyStreak;

  final dayLabels = ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));

  final rows = await _client
      .from('daily_activity')
      .select('activity_date')
      .eq('user_id', userId)
      .eq('is_active', true)
      .gte('activity_date', monday.toIso8601String().split('T')[0]);

  final activeDates = (rows as List)
      .map((r) => r['activity_date'] as String)
      .toSet();

  int streakCount = 0;
  final days = List.generate(7, (i) {
    final date = monday.add(Duration(days: i));
    final dateStr = date.toIso8601String().split('T')[0];
    final completed = activeDates.contains(dateStr);
    if (completed) streakCount++;
    return StreakDay(
      label: dayLabels[i],
      completed: completed,
      isToday: date == today,
    );
  });

  return WeeklyStreak(
    title: '$streakCount günlük seri 🔥',
    statusLabel: streakCount > 0 ? 'devam ediyor' : 'başlamadı',
    days: days,
  );
});

final subjectDistributionProvider = FutureProvider.autoDispose<List<SubjectDistribution>>((ref) async {
  final userId = _userId;
  if (userId == null) return ProfileMockData.subjectDistribution;

  final dersler = await _client
      .from('dersler')
      .select()
      .eq('user_id', userId)
      .order('created_at');

  if ((dersler as List).isEmpty) return [];

  final result = <SubjectDistribution>[];
  int maxCount = 1;
  final counts = <String, int>{};

  for (final ders in dersler) {
    final count = await _client
        .from('notes')
        .select('id')
        .eq('user_id', userId)
        .eq('subject_id', ders['id']);
    final c = (count as List).length;
    counts[ders['ders_adi']] = c;
    if (c > maxCount) maxCount = c;
  }

  for (final ders in dersler) {
    final name = ders['ders_adi'] as String;
    final count = counts[name] ?? 0;
    result.add(SubjectDistribution(
      name: name,
      noteCount: count,
      ratio: count == 0 ? 0 : count / maxCount,
    ));
  }

  return result;
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