import 'package:flutter/material.dart';

/// Centralized semantic color tokens for FreshCheck.
///
/// Usage: `AppColors.primary`, `AppColors.textSecondary`, etc.
/// Never hardcode color values in widgets — always reference this class.
class AppColors {
  AppColors._();

  // ── Brand Colors ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFFE8F5E9);
  static const Color primaryDark = Color(0xFF2E7D32);

  static const Color secondary = Color(0xFF424242);
  static const Color secondaryLight = Color(0xFF757575);
  static const Color secondaryDark = Color(0xFF212121);

  // ── Background & Surface ────────────────────────────────────────────────
  static const Color scaffoldBackground = Colors.white;
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);
  static const Color card = Colors.white;

  // ── Text Colors ─────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textInverse = Colors.white;

  // ── Border & Divider ────────────────────────────────────────────────────
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);

  // ── Button Colors ───────────────────────────────────────────────────────
  static const Color buttonPrimary = Color(0xFF4CAF50);
  static const Color buttonSecondary = Color(0xFF424242);
  static const Color buttonDisabled = Color(0xFF9E9E9E);

  // ── Input Field Colors ──────────────────────────────────────────────────
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocusedBorder = Color(0xFF4CAF50);
  static const Color inputErrorBorder = Color(0xFFE53935);
  static const Color inputFill = Color(0xFFF5F5F5);

  // ── Icon Colors ─────────────────────────────────────────────────────────
  static const Color iconPrimary = Color(0xFF4CAF50);
  static const Color iconSecondary = Color(0xFF9E9E9E);
  static const Color iconDisabled = Color(0xFF9E9E9E);

  // ── Status Colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF29B6F6);

  // ── Overlay Colors ──────────────────────────────────────────────────────
  static const Color overlay = Color(0x80000000);
  static const Color shadow = Color(0x1A000000);

  // ── Auth Accent Colors ─────────────────────────────────────────────────
  static const Color coral = Color(0xFFF27C79);
  static const Color coralLight = Color(0xFFF9A8A6);
  static const Color coralDark = Color(0xFFE8605D);

  // ── Social Brand Colors ─────────────────────────────────────────────────
  static const Color googleRed = Color(0xFFDB4437);
  static const Color facebookBlue = Color(0xFF1877F2);

  // ── Shimmer Colors ──────────────────────────────────────────────────────
  static final Color shimmerBase = Colors.grey.shade300;
  static final Color shimmerHighlight = Colors.grey.shade100;
}
