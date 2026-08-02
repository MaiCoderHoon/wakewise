import 'package:flutter/material.dart';
import '../../core/constants/theme/app_spacing.dart';

/// WakeWise Reusable Page Scaffold
/// Provides consistent page structure with circadian background gradient,
/// safe area inset handling, and generous responsive padding.
class AppPageScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool isScrollable;
  final EdgeInsetsGeometry padding;
  final bool applySafeArea;
  final Widget? header;
  final LinearGradient? backgroundGradient;

  const AppPageScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.isScrollable = true,
    this.padding = AppSpacing.pagePadding,
    this.applySafeArea = true,
    this.header,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = body;

    if (header != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header!,
          AppSpacing.gapH24,
          Expanded(child: body),
        ],
      );
    } else if (isScrollable) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: padding,
        child: body,
      );
    } else {
      content = Padding(
        padding: padding,
        child: content,
      );
    }

    if (applySafeArea && header == null) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          gradient: backgroundGradient,
        ),
        child: content,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
