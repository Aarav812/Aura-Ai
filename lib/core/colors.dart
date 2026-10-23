import 'package:flutter/material.dart';

/// Aura AI brand palette.
///
/// Colours are sampled from the app icon: a deep space background with an
/// electric blue → violet gradient and a cyan highlight.
class AppColors {
  AppColors._();

  // ── Brand ──
  static const Color primary = Color(0xFF3B82F6); // electric blue
  static const Color primaryDim = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF8B5CF6); // violet
  static const Color tertiary = Color(0xFF22D3EE); // cyan
  static const Color accent = Color(0xFFC084FC); // orchid

  static const Color gradientStart = Color(0xFF22D3EE);
  static const Color gradientMid = Color(0xFF3B82F6);
  static const Color gradientEnd = Color(0xFF8B5CF6);

  /// The signature Aura AI gradient (cyan → blue → violet).
  static const List<Color> brandGradient = [
    gradientStart,
    gradientMid,
    gradientEnd,
  ];

  /// Slightly deeper variant for surfaces that carry white text/icons.
  static const List<Color> bubbleGradient = [
    primaryDim,
    Color(0xFF4F46E5),
    secondary,
  ];

  // ── Semantic ──
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF22D3EE);

  // ── Text (dark mode defaults — theme overrides for light) ──
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA7B4CC);
  static const Color textMuted = Color(0xFF7C8AA5);

  // ── Backgrounds (dark mode) ──
  static const Color bg = Color(0xFF05070F);
  static const Color surface = Color(0xFF0B1220);
  static const Color surfaceLight = Color(0xFF141E33);
  static const Color card = Color(0xFF0B1220);

  // ── Backgrounds (light mode) ──
  static const Color lightBg = Color(0xFFF6F8FF);
  static const Color lightSurface = Color(0xFFF1F5FD);
  static const Color lightSurfaceHigh = Color(0xFFE9EEFA);
  static const Color lightBorder = Color(0xFFDCE4F5);
  static const Color lightTextPrimary = Color(0xFF0B1220);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF64748B);

  // ── Chat Bubbles ──
  static const Color userBubble = Color(0xFF3B82F6);
  static const Color aiBubble = Color(0xFF0B1220);
  static const Color cmdBubble = Color(0xFF0E2A20);

  // ── Border ──
  static const Color border = Color(0xFF1C2740);
  static const Color borderLight = Color(0xFF2A3855);
}
