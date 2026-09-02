import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_theme_extension.dart';
import '../../../homepage/presentation/screens/home_screen.dart';
import '../providers/user_session_provider.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/otp_code_input.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key, this.email});

  final String? email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  static const int _resendSeconds = 45;

  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  String _code = '';
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _formattedCountdown {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verify() async {
    final email = widget.email?.trim();
    if (email == null || email.isEmpty || _code.length != 6) return;

    setState(() => _isVerifying = true);
    try {
      await ref
          .read(userSessionProvider.notifier)
          .verifyCode(email: email, token: _code);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doğrulama başarısız: $e')),
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resend() async {
    final email = widget.email?.trim();
    if (email == null || email.isEmpty) return;

    setState(() => _isResending = true);
    try {
      await ref.read(userSessionProvider.notifier).resendCode(email: email);
      _startCountdown();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kod gönderilemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final canResend = _secondsLeft == 0;
    final email = widget.email?.trim();

    return AuthScreenScaffold(
      children: [
        const AuthBackButton(),
        SizedBox(height: 28.h),
        Center(child: _MailBadge()),
        SizedBox(height: 20.h),
        Text(
          'E-postanı doğrula',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Doğrulama kodu şu adrese gönderildi:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: appColors.textSecondary),
        ),
        SizedBox(height: 2.h),
        Text(
          (email == null || email.isEmpty) ? 'e-posta adresin' : email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 26.h),
        OtpCodeInput(
          onChanged: (value) => setState(() => _code = value),
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: canResend ? _resend : null,
          child: Text.rich(
            TextSpan(
              text: 'Kod gelmedi mi? ',
              style: TextStyle(fontSize: 12.sp, color: appColors.textSecondary),
              children: [
                TextSpan(
                  text: canResend
                      ? 'Tekrar gönder'
                      : 'Tekrar gönder ($_formattedCountdown)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        SizedBox(height: 20.h),
        AuthPrimaryButton(
          label: _isVerifying ? 'Doğrulanıyor...' : 'Doğrula ve Devam Et',
          onPressed: (_isVerifying || _code.length != 6)
              ? () {}
              : () { _verify(); },
        ),
      ],
    );
  }
}

class _MailBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(
        Icons.mark_email_read_outlined,
        size: 26.sp,
        color: Colors.white,
      ),
    );
  }
}