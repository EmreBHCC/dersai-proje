import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/user_session.dart';

/// App-wide session state. `null` means no user is signed in.
///
/// Passwordless flow: the user only enters their email. Supabase sends a
/// 6-digit code (OTP), and [verifyCode] completes the sign-in/sign-up.
class UserSessionNotifier extends Notifier<UserSession?> {
  final _supabase = Supabase.instance.client;

  /// Kept between "send code" and "verify code" so we can build the display
  /// name once the user is confirmed.
  String? _pendingFullName;

  @override
  UserSession? build() => null;

  /// Sign-up flow: sends a one-time code to the given email.
  /// The account isn't created yet — that happens in [verifyCode].
  Future<void> signUp({required String fullName, required String email}) async {
    _pendingFullName = fullName.trim();
    await _supabase.auth.signInWithOtp(email: email.trim());
  }

  /// Login flow: sends a one-time code to an existing account's email.
  Future<void> logIn({required String email}) async {
    _pendingFullName = null;
    await _supabase.auth.signInWithOtp(email: email.trim());
  }

  /// Called from the verification screen once the user enters the 6-digit
  /// code. Completes sign-up or sign-in and updates the session state.
  Future<void> verifyCode({required String email, required String token}) async {
    final response = await _supabase.auth.verifyOTP(
      email: email.trim(),
      token: token,
      type: OtpType.email,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Doğrulama başarısız oldu.');
    }

    final name = _pendingFullName;
    if (name != null && name.isNotEmpty) {
      await _supabase.auth.updateUser(UserAttributes(data: {'full_name': name}));
    }

    final metaName = user.userMetadata?['full_name'] as String?;
    final resolvedName = (name != null && name.isNotEmpty)
        ? name
        : (metaName == null || metaName.isEmpty)
            ? _nameFromEmail(email)
            : metaName;

    state = UserSession(fullName: resolvedName, email: email.trim());
    _pendingFullName = null;
  }

  /// Resends the one-time code to the given email.
  Future<void> resendCode({required String email}) async {
    await _supabase.auth.signInWithOtp(email: email.trim());
  }

  void updateName(String fullName) {
    final current = state;
    final name = fullName.trim();
    if (current == null || name.isEmpty) return;
    state = current.copyWith(fullName: name);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = null;
  }

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