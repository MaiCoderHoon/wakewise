import 'package:flutter/material.dart';
import '../../core/constants/theme/app_animations.dart';

/// Animated numeric counter that tweens from [begin] to [value].
/// Use for XP display, streak counts, and any numeric reward reveal.
class AnimatedCounter extends StatefulWidget {
  final int value;
  final int begin;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.begin = 0,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = AppAnimations.slow,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = IntTween(begin: widget.begin, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.decelerate),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = IntTween(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.decelerate));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Text(
        '${widget.prefix}${_animation.value}${widget.suffix}',
        style: widget.style,
      ),
    );
  }
}
