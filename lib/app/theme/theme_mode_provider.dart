import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Uygulamanın açık/koyu tema seçimini tutar.
/// Profil sayfasındaki Karanlık Mod anahtarı bunu değiştirir.
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});