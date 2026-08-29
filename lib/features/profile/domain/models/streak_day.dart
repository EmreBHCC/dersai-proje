class StreakDay {
  const StreakDay({
    required this.label,
    required this.completed,
    this.isToday = false,
  });

  final String label;
  final bool completed;
  final bool isToday;
}

class WeeklyStreak {
  const WeeklyStreak({
    required this.title,
    required this.statusLabel,
    required this.days,
  });

  final String title;
  final String statusLabel;
  final List<StreakDay> days;
}
