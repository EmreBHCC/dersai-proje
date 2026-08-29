import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_brand_header.dart';
import '../widgets/auth_field_label.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_screen_scaffold.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final target = email.isEmpty ? 'e-posta adresine' : '$email adresine';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Sıfırlama bağlantısı $target gönderildi.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenScaffold(
      children: [
        const AuthBackButton(),
        SizedBox(height: 6.h),
        const AuthBrandHeader(),
        SizedBox(height: 28.h),
        Center(child: _LockBadge()),
        SizedBox(height: 20.h),
        Text(
          'Şifreni sıfırla',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Kayıtlı e-posta adresini gir, sana sıfırlama bağlantısı gönderelim.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.lightTextSecondary,
            height: 1.4,
          ),
        ),
        SizedBox(height: 24.h),
        const AuthFieldLabel('E-posta'),
        AuthTextField(
          controller: _emailController,
          hintText: 'ornek@mail.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          highlighted: true,
          autofillHints: const [AutofillHints.email],
        ),
        const Spacer(),
        SizedBox(height: 20.h),
        AuthPrimaryButton(
          label: 'Sıfırlama Bağlantısı Gönder',
          onPressed: _submit,
        ),
        SizedBox(height: 22.h),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: Text.rich(
              TextSpan(
                text: 'Şifreni hatırladın mı? ',
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

class _LockBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(Icons.lock_reset_rounded, size: 26.sp, color: Colors.white),
    );
  }
}
