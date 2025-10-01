// countdown_app/lib/core/theme/typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  /// Base text theme
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 52,
      fontWeight: FontWeight.w800,
      height: 1.1,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );

  /// Explicit named aliases for easier widget usage
  static TextStyle get h1 => textTheme.displayLarge!;
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ); // extra heading between h1 and headlineMedium
  static TextStyle get headline => textTheme.headlineMedium!;
  static TextStyle get bodyLarge => textTheme.bodyLarge!;
  static TextStyle get bodySmall => textTheme.bodySmall!;
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get label => textTheme.labelLarge!;
}
