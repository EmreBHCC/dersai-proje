import 'package:flutter/material.dart';

class TodaysSummary {
  const TodaysSummary({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.metaIcon,
    required this.metaLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final IconData metaIcon;
  final String metaLabel;
}
