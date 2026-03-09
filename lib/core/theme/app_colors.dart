import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF0A73E8);
  static const Color primaryDark = Color(0xFF0557B5);
  static const Color primaryLight = Color(0xFF4DA3FF);

  // Secondary / Accent
  static const Color secondary = Color(0xFF00C2A8);
  static const Color secondaryDark = Color(0xFF009984);
  static const Color secondaryLight = Color(0xFF4DDECA);

  // Background
  static const Color background = Color(0xFFF4F7FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEBF1FF);

  // Text
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF8A94A6);
  static const Color textHint = Color(0xFFB8C1CE);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Card
  static const Color cardShadow = Color(0x1A0A73E8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A73E8), Color(0xFF00C2A8)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0557B5), Color(0xFF0A73E8), Color(0xFF00C2A8)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A7BE8), Color(0xFF0A5FC2)],
  );

  // Specialty Colors
  static const Color specialtyGeneral = Color(0xFF0A73E8);
  static const Color specialtyDentist = Color(0xFF8B5CF6);
  static const Color specialtyHeart = Color(0xFFEF4444);
  static const Color specialtyChild = Color(0xFFF59E0B);
  static const Color specialtyEye = Color(0xFF00C2A8);
  static const Color specialtyBone = Color(0xFF6366F1);

  // Overlay
  static const Color overlay = Color(0x801A1F36);
}
