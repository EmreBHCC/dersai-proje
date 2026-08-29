import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_theme_extension.dart';
import '../../../homepage/presentation/screens/home_screen.dart';
import '../providers/user_session_provider.dart';
import '../widgets/auth_brand_header.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToHome() {
    ref.read(userSessionProvider.notifier).logIn(email: _emailController.text);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _goToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  void _goToForgotPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
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
        SizedBox(height: 16.h),
        const AuthFieldLabel('Şifre'),
        AuthTextField(
          controller: _passwordController,
          hintText: 'Şifreni gir',
          icon: Icons.lock_outline_rounded,
          obscure: true,
          autofillHints: const [AutofillHints.password],
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _goToForgotPassword,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Şifremi unuttum',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(height: 20.h),
        AuthPrimaryButton(label: 'Giriş Yap', onPressed: _goToHome),
        SizedBox(height: 20.h),
        const AuthDivider(),
        SizedBox(height: 20.h),
        SocialAuthButton(
          icon: Icons.g_mobiledata_rounded,
          iconSize: 26.sp,
          label: 'Google ile devam et',
          onPressed: () {},
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
