import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 52, fontWeight: FontWeight.w800, height: 1.1),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.w700),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w600),
  );
}
