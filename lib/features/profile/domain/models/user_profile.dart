import 'profile_stat.dart';

class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.initials,
    required this.verifiedLabel,
    required this.stats,
  });

  final String fullName;
  final String initials;
  final String verifiedLabel;
  final List<ProfileStat> stats;
}
