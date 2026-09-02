import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_theme_extension.dart';
import '../providers/user_session_provider.dart';
import '../widgets/auth_brand_header.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_text_field.dart';
import 'email_verification_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _goToVerification() async {
    final email = _emailController.text.trim();

    setState(() => _isLoading = true);
    try {
      await ref.read(userSessionProvider.notifier).logIn(email: email);

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EmailVerificationScreen(email: email)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return AuthScreenScaffold(
      children: [
        SizedBox(height: 8.h),
        const AuthBrandHeader(),
        SizedBox(height: 28.h),
        Text(
          'Tekrar hoş geldin',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Devam etmek için giriş yap',
          style: TextStyle(fontSize: 13.sp, color: appColors.textSecondary),
        ),
        SizedBox(height: 24.h),
        const AuthFieldLabel('E-posta'),
        AuthTextField(
          controller: _emailController,
          hintText: 'ornek@mail.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
        ),
        
      
        const Spacer(),
        SizedBox(height: 20.h),
        AuthPrimaryButton(
          label: _isLoading ? 'Gönderiliyor...' : 'Doğrulama Kodu Gönder',
          onPressed: _isLoading ? () {} : () { _goToVerification(); },
        ),
        SizedBox(height: 22.h),
        Center(
          child: GestureDetector(
            onTap: _goToSignup,
            behavior: HitTestBehavior.opaque,
            child: Text.rich(
              TextSpan(
                text: 'Hesabın yok mu? ',
                style: TextStyle(fontSize: 12.sp, color: appColors.textSecondary),
                children: [
                  TextSpan(
                    text: 'Kayıt ol',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}