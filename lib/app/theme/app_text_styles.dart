import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle greeting(Color color) => _base(
        size: 28,
        weight: FontWeight.w800,
        color: color,
        letterSpacing: -0.4,
        height: 1.2,
      );

  static TextStyle greetingSubtitle(Color color) => _base(
        size: 15,
        weight: FontWeight.w600,
        color: color,
        height: 1.35,
      );

  static TextStyle sectionTitle(Color color) => _base(
        size: 18,
        weight: FontWeight.w700,
        color: color,
        letterSpacing: -0.2,
      );

  static TextStyle sectionAction(Color color) => _base(
        size: 13,
        weight: FontWeight.w700,
        color: color,
      );

  static TextStyle cardTitle(Color color) => _base(
        size: 15,
        weight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle body(Color color) => _base(
        size: 14,
        weight: FontWeight.w500,
        color: color,
        height: 1.4,
      );

  static TextStyle metadata(Color color) => _base(
        size: 12,
        weight: FontWeight.w600,
        color: color,
        height: 1.3,
      );

  static TextStyle buttonLabel(Color color) => _base(
        size: 13,
        weight: FontWeight.w700,
        color: color,
      );

  static TextStyle navLabel(Color color) => _base(
        size: 11,
        weight: FontWeight.w700,
        color: color,
      );

  static TextStyle statValue(Color color) => _base(
        size: 20,
        weight: FontWeight.w800,
        color: color,
        letterSpacing: -0.3,
      );
}
