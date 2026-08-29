import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_theme_extension.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.obscure = false,
    this.highlighted = false,
    this.autofillHints,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final bool highlighted;
  final Iterable<String>? autofillHints;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final borderColor = widget.highlighted
        ? theme.colorScheme.primary
        : appColors.border;
    final iconColor = widget.highlighted
        ? theme.colorScheme.primary
        : appColors.textTertiary;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
        border: Border.all(
          color: borderColor,
          width: widget.highlighted ? 1 : 0.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Icon(widget.icon, size: 16.sp, color: iconColor),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: _obscured,
              autofillHints: widget.autofillHints,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface,
              ),
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: appColors.textTertiary,
                ),
              ),
            ),
          ),
          if (widget.obscure)
            GestureDetector(
              onTap: () => setState(() => _obscured = !_obscured),
              behavior: HitTestBehavior.opaque,
              child: Icon(
                _obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 16.sp,
                color: appColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }
}
