import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF07090F);
  static const Color surface    = Color(0xFF0F1320);
  static const Color card       = Color(0xFF14182A);

  static const Color lavender   = Color(0xFF9B7FD4);
  static const Color softPink   = Color(0xFFE8A0BF);
  static const Color deepPurple = Color(0xFF3D1A78);
  static const Color gold       = Color(0xFFD4AF37);
  static const Color champagne  = Color(0xFFF7E7CE);

  static const Color textPrimary   = Color(0xFFF0EBF8);
  static const Color textSecondary = Color(0xFF8A8099);
  static const Color textHint      = Color(0xFF3E3A50);

  static const Color glassWhite  = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C0A18), Color(0xFF07090F), Color(0xFF080C1C)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [lavender, softPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFB8922A), Color(0xFFF7E7CE), Color(0xFFB8922A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
