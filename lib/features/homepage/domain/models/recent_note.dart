import 'package:flutter/material.dart';

class RecentNote {
  const RecentNote({
    required this.id,
    required this.title,
    required this.newItemsLabel,
    required this.accentColor,
    required this.previewIcon,
    this.content = '',
    this.createdAt,
    this.type = '',
  });

  final String id;
  final String title;
  final String newItemsLabel;
  final Color accentColor;
  final IconData previewIcon;
  final String content;
  final DateTime? createdAt;
  final String type;
}