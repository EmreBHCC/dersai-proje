import 'package:flutter/material.dart';

enum ProfileActivityTone { primary, neutral, success }

class ProfileActivity {
  const ProfileActivity({
    required this.icon,
    required this.title,
    required this.timeLabel,
    required this.tone,
  });

  final IconData icon;
  final String title;
  final String timeLabel;
  final ProfileActivityTone tone;
}
