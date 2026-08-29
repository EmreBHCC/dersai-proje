import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_session.dart';

class UserSessionNotifier extends Notifier<UserSession?> {
  @override
  UserSession? build() => null;

  void signUp({required String fullName, required String email}) {
    final name = fullName.trim();
    state = UserSession(
      fullName: name.isEmpty ? _nameFromEmail(email) : name,
      email: email.trim(),
    );
  }

  void logIn({required String email}) {
    state = UserSession(fullName: _nameFromEmail(email), email: email.trim());
  }

  void updateName(String fullName) {
    final current = state;
    final name = fullName.trim();
    if (current == null || name.isEmpty) return;
    state = current.copyWith(fullName: name);
  }

  void signOut() => state = null;

  static String _nameFromEmail(String email) {
    final local = email.trim().split('@').first;
    final words = local
        .split(RegExp(r'[._\-+]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1));
    final joined = words.join(' ');
    return joined.isEmpty ? 'Öğrenci' : joined;
  }
}

final userSessionProvider = NotifierProvider<UserSessionNotifier, UserSession?>(
  UserSessionNotifier.new,
);
