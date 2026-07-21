import 'package:flutter/material.dart';

class QuickAction {
  const QuickAction({
    required this.id,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  final String id;
  final IconData icon;
  final String label;
  final bool isPrimary;
}
