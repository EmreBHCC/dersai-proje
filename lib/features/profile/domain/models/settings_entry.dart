import 'package:flutter/material.dart';

enum SettingsEntryKind { toggle, navigation }

class SettingsEntry {
  const SettingsEntry({
    required this.id,
    required this.icon,
    required this.label,
    required this.kind,
    this.highlighted = true,
    this.initialValue = false,
  });

  final String id;
  final IconData icon;
  final String label;
  final SettingsEntryKind kind;
  final bool highlighted;
  final bool initialValue;
}
