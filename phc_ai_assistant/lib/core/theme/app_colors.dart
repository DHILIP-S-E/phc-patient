// ============================================================
// PHC AI Assistant - App Colors
// Healthcare-themed color system using HSL for precision
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Primary ──────────────────────────────────────────
  /// Deep medical teal — evokes trust, calm, healthcare
  static const Color primary = Color(0xFF006D77);
  static const Color primaryLight = Color(0xFF83C5BE);
  static const Color primaryDark = Color(0xFF004D56);
  static const Color primaryContainer = Color(0xFFB2DFDB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF002020);

  // ── Accent ────────────────────────────────────────────────
  /// Warm saffron — Indian cultural touch
  static const Color accent = Color(0xFFFF9933);
  static const Color accentLight = Color(0xFFFFBD70);
  static const Color accentDark = Color(0xFFCC7A00);
  static const Color accentContainer = Color(0xFFFFE0B2);

  // ── Secondary ─────────────────────────────────────────────
  /// Soft jade — secondary healthcare color
  static const Color secondary = Color(0xFF52B788);
  static const Color secondaryLight = Color(0xFF95D5B2);
  static const Color secondaryDark = Color(0xFF2D6A4F);
  static const Color secondaryContainer = Color(0xFFD8F3DC);

  // ── Surface / Background ──────────────────────────────────
  static const Color background = Color(0xFF0A1628);
  static const Color backgroundLight = Color(0xFF0F1E35);
  static const Color surface = Color(0xFF122040);
  static const Color surfaceVariant = Color(0xFF1A2E50);
  static const Color surfaceElevated = Color(0xFF1E3660);

  // ── Glassmorphism surface
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassDark = Color(0x33000000);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFFB0C4DE);
  static const Color textTertiary = Color(0xFF7A92B0);
  static const Color textDisabled = Color(0xFF4A6280);
  static const Color textOnAccent = Color(0xFF1A0A00);

  // ── Status Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFA5D6A7);
  static const Color successContainer = Color(0xFF1B5E20);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFCC80);
  static const Color warningContainer = Color(0xFFE65100);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF9A9A);
  static const Color errorContainer = Color(0xFFB71C1C);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF90CAF9);

  // ── Voice / Waveform ─────────────────────────────────────
  static const Color waveformActive = Color(0xFF83C5BE);
  static const Color waveformInactive = Color(0xFF2D4A6A);
  static const Color micActive = Color(0xFFFF5252);
  static const Color micInactive = Color(0xFF006D77);

  // ── Download Progress ─────────────────────────────────────
  static const Color downloadTrack = Color(0xFF1A2E50);
  static const Color downloadFill = Color(0xFF006D77);
  static const Color downloadGlow = Color(0x5583C5BE);

  // ── Avatar Glow ───────────────────────────────────────────
  static const Color avatarGlow = Color(0x4483C5BE);
  static const Color avatarGlowSpeaking = Color(0x44FF9933);
  static const Color avatarGlowListening = Color(0x44FF5252);
  static const Color avatarGlowThinking = Color(0x4452B788);

  // ── Gradient Presets ─────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1628), Color(0xFF0D1F3C), Color(0xFF071220)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF006D77), Color(0xFF52B788)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9933), Color(0xFFFFBD70)],
  );

  static const RadialGradient avatarGlowGradient = RadialGradient(
    colors: [Color(0x6683C5BE), Color(0x0083C5BE)],
    radius: 0.8,
  );

  // ── Shadows ───────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get primaryGlowShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.4),
          blurRadius: 24,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> get avatarShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.3),
          blurRadius: 40,
          spreadRadius: 10,
        ),
      ];
}
