import 'package:flutter/material.dart';

class AppColors {
  // ========== Primary ================================
  static const Color primary       = Color(0xFF00A651);
  static const Color primaryDark   = Color(0xFF007D3D);
  static const Color primaryDarker = Color(0xFF004B24);
  static const Color primarySoft   = Color(0xFFE6F7EE); // tinted bg for badges/chips

  // ========== Neutral Scale ================================

  // Text
  static const Color textHeading   = Color(0xFF1A1D23); // near-black, replaces pure black
  static const Color textPrimary   = Color(0xFF3B3E45); // body copy
  static const Color textSecondary = Color(0xFF737A87); // captions, hints
  static const Color textDisabled  = Color(0xFFB0B5BF); // disabled / placeholder

  // Surfaces — layered from darkest bg → lightest card
  static const Color background    = Color(0xFFF4F5F7); // page bg — cool off-white
  static const Color surface       = Color(0xFFFFFFFF); // cards, sheets — pure white pops cleanly on F4F5F7
  static const Color surfaceRaised = Color(0xFFF9FAFB); // subtle inner sections inside cards
  static const Color surfaceBorder = Color(0xFFE8EAED); // dividers, input borders

  // ========== Status Colors ================================
  static const Color error        = Color(0xFFD93025); // desaturated red
  static const Color errorSoft    = Color(0xFFFCE8E6);
  static const Color success      = Color(0xFF1E7E34); // darker teal-green, distinct from primary
  static const Color successSoft  = Color(0xFFE6F4EA);
  static const Color warning      = Color(0xFFB06000); // amber-brown, readable
  static const Color warningSoft  = Color(0xFFFEF3E2);
  static const Color info         = Color(0xFF1A73E8);
  static const Color infoSoft     = Color(0xFFE8F0FE);

  // ========== Semantic Tokens ================================
  static const Color cardBackground    = surface;
  static const Color appBarBackground  = background;   // matches page — no weight inversion
  static const Color navBarBackground  = surface;      // white nav on grey bg = clean lift
  static const Color divider           = surfaceBorder;
  static const Color inputFill         = surfaceRaised;
  static const Color shimmerBase       = Color(0xFFE8EAED);
  static const Color shimmerHighlight  = Color(0xFFF4F5F7);
  static const Color overlay           = Color(0x1A000000); // 10% black — replaces scattered withOpacity(0.04-0.06)
  static const Color overlayMedium     = Color(0x33000000); // 20% black
  static const Color overlayDark       = Color(0x80000000); // 50% black — image overlays

  // ========== AI Gradient ================================
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF004B24), Color(0xFF00A651)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========== Legacy Aliases ================================
  static const Color black         = textHeading;
  static const Color white         = surface;
  static const Color card          = surface;
  static const Color surfaceVariant = surfaceBorder;
  static const Color iconPrimary   = textPrimary;
  static const Color iconMuted     = textSecondary;
}
