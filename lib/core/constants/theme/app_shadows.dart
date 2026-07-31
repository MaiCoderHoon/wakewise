import 'package:flutter/material.dart';

/// WakeWise Soft Shadow Design System
/// Soft, diffused warm shadows giving a modern, elevated feel.
abstract class AppShadows {
  /// Subtle elevation for cards and containers
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0C8C420D), // Ultra-soft warm brown/orange ambient tint
      blurRadius: 16.0,
      offset: Offset(0, 6),
      spreadRadius: -2.0,
    ),
    BoxShadow(
      color: Color(0x08000000), // Subtle grounding shadow
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium elevation for interactive cards & active dialogs
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x148C420D),
      blurRadius: 24.0,
      offset: Offset(0, 10),
      spreadRadius: -4.0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ];

  /// Warm yellow/orange ambient glow shadow for primary call-to-action buttons
  static const List<BoxShadow> buttonGlow = [
    BoxShadow(
      color: Color(0x40F8B133), // Golden yellow glow
      blurRadius: 20.0,
      offset: Offset(0, 8),
      spreadRadius: -2.0,
    ),
  ];

  /// Floating element / alarm action shadow
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x1FFF8C42), // Warm sunrise orange glow
      blurRadius: 28.0,
      offset: Offset(0, 12),
      spreadRadius: -4.0,
    ),
  ];

  /// Elevated card with stronger warm ambient depth — for hero/accent cards
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A8C420D),
      blurRadius: 20.0,
      offset: Offset(0, 8),
      spreadRadius: -3.0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 6.0,
      offset: Offset(0, 3),
    ),
  ];

  /// Strong coloured glow used for hero badge highlights and celebration elements
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x4DFF8C42), // ~30% orange glow
      blurRadius: 32.0,
      offset: Offset(0, 0),
      spreadRadius: 4.0,
    ),
  ];
}
