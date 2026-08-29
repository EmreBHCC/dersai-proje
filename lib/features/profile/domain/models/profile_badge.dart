import 'package:flutter/material.dart';

class ProfileBadge {
  const ProfileBadge({
    required this.icon,
    required this.label,
    required this.unlocked,
  });

  final IconData icon;
  final String label;
  final bool unlocked;
}
