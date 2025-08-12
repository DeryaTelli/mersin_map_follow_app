import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle nunitoSemiBold20White40 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Colors.white60,
  );

  static const TextStyle nunitoExtraBold16White = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w800,
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: 0,
    color: Colors.white,
  );

  static const TextStyle nunitoRegular16Gray = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 18.8 / 16,
    letterSpacing: -0.23,
    color: Color(0xFF8E8E93),
  );

  static const TextStyle nunitoRegular16 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 18.8 / 16,
    letterSpacing: -0.23,
    color: Color.fromARGB(255, 54, 54, 54),
  );

  static final TextStyle orelegaOneRegular20Purple = TextStyle(
    fontFamily: GoogleFonts.palanquinDark().fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: const Color(0xFFEDE0F6),
  );

  static const TextStyle nunitoRegular14Purple = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0,
    color: Color(0xFFEDE0F6),
  );

  static const TextStyle nunitoBold16White = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0,
    color: Colors.white,
  );

  static const TextStyle nunitoSansSemiBold12Black = TextStyle(
    fontFamily: 'Nunito Sans',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    letterSpacing: 1,
    color: Color(0xFF1E2022),
  );
}
