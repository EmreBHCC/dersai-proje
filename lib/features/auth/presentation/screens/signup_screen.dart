import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../providers/user_session_provider.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_brand_header.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_text_field.dart';
import 'email_verification_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToVerification() {
    final email = _emailController.text.trim();
    ref
        .read(userSessionProvider.notifier)
        .signUp(fullName: _nameController.text, email: email);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EmailVerificationScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      children: [
        const AuthBackButton(),
        SizedBox(height: 6.h),
        const AuthBrandHeader(),
        SizedBox(height: 26.h),
        Text(
          'Hesap oluştur',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Akıllı çalışma asistanına katıl',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightTextSecondary,
          ),
        ),
        SizedBox(height: 24.h),
        const AuthFieldLabel('Ad Soyad'),
        AuthTextField(
          controller: _nameController,
          hintText: 'Adını gir',
          icon: Icons.person_outline_rounded,
          keyboardType: TextInputType.name,
          autofillHints: const [AutofillHints.name],
        ),
        SizedBox(height: 16.h),
        const AuthFieldLabel('E-posta'),
        AuthTextField(
          controller: _emailController,
          hintText: 'ornek@mail.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          highlighted: true,
          autofillHints: const [AutofillHints.email],
        ),
        SizedBox(height: 16.h),
        const AuthFieldLabel('Şifre oluştur'),
        AuthTextField(
          controller: _passwordController,
          hintText: 'En az 8 karakter',
          icon: Icons.lock_outline_rounded,
          obscure: true,
          autofillHints: const [AutofillHints.newPassword],
        ),
        SizedBox(height: 10.h),
        Text.rich(
          TextSpan(
            text: 'Devam ederek ',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.lightTextTertiary,
            ),
            children: [
              TextSpan(
                text: 'Kullanım Şartları',
                style: const TextStyle(color: AppColors.primary),
              ),
              const TextSpan(text: '\'nı kabul edersin.'),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(height: 20.h),
        AuthPrimaryButton(
          label: 'Doğrulama Kodu Gönder',
          onPressed: _goToVerification,
        ),
        SizedBox(height: 22.h),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: Text.rich(
              TextSpan(
                text: 'Zaten hesabın var mı? ',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.lightTextSecondary,
                ),
                children: [
                  TextSpan(
                    text: 'Giriş yap',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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
