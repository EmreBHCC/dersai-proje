import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_session.dart';

/// App-wide session state. `null` means no user is signed in.
///
/// Screens read the display name through this provider (directly or via the
/// `userFirstNameProvider` / `userFullNameProvider` wrappers) so the name the
/// user types during login / sign-up shows up everywhere.
class UserSessionNotifier extends Notifier<UserSession?> {
  @override
  UserSession? build() => null;

  /// Sign-up flow: the user typed their name explicitly.
  void signUp({required String fullName, required String email}) {
    final name = fullName.trim();
    state = UserSession(
      fullName: name.isEmpty ? _nameFromEmail(email) : name,
      email: email.trim(),
    );
  }

  /// Login flow: no name field, so derive a display name from the e-mail.
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

  /// "ece.yilmaz@mail.com" -> "Ece Yilmaz".
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
