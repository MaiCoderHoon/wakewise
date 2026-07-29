import 'package:flutter/material.dart';

/// WakeWise Spacing & Radius System
/// Generous spacing tokens and large rounded corners (24-32px) for modern productivity aesthetic.
abstract class AppSpacing {
  // Spacing Scale
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Corner Radius Tokens
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0; // Standard card corner radius
  static const double radiusXl = 32.0; // Large container / primary button radius
  static const double radiusFull = 999.0; // Pill / circle radius

  // BorderRadius Helpers
  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // EdgeInsets Padding Helpers
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingVertSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVertMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVertLg = EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // Gap / Spacer Widgets
  static const SizedBox gapH4 = SizedBox(height: xxs);
  static const SizedBox gapH8 = SizedBox(height: xs);
  static const SizedBox gapH12 = SizedBox(height: sm);
  static const SizedBox gapH16 = SizedBox(height: md);
  static const SizedBox gapH24 = SizedBox(height: lg);
  static const SizedBox gapH32 = SizedBox(height: xl);
  static const SizedBox gapH48 = SizedBox(height: xxl);

  static const SizedBox gapW4 = SizedBox(width: xxs);
  static const SizedBox gapW8 = SizedBox(width: xs);
  static const SizedBox gapW12 = SizedBox(width: sm);
  static const SizedBox gapW16 = SizedBox(width: md);
  static const SizedBox gapW24 = SizedBox(width: lg);
  static const SizedBox gapW32 = SizedBox(width: xl);
}
