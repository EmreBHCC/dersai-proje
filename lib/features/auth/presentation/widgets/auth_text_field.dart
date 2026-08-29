import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';

/// Single-line input used across the auth screens: white surface, rounded
/// border, a leading icon and — for passwords — a trailing show/hide toggle.
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

  /// Whether this is a password field (renders the eye toggle + obscures text).
  final bool obscure;

  /// Draws the field with the primary-colored border and icon, matching the
  /// "focused / active" field in the design.
  final bool highlighted;

  final Iterable<String>? autofillHints;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.highlighted
        ? AppColors.primary
        : AppColors.lightBorder;
    final iconColor = widget.highlighted
        ? AppColors.primary
        : AppColors.lightTextTertiary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
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
                color: AppColors.lightTextPrimary,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.lightTextTertiary,
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
                color: AppColors.lightTextTertiary,
              ),
            ),
        ],
      ),
    );
  }
}
