import 'package:flutter/material.dart';
import 'package:frontend/common/consts/data.dart';

class AnimatedAppName extends StatefulWidget {
  final String appName;
  final double fontSize;
  const AnimatedAppName({
    super.key,
    this.appName = APP_NAME,
    this.fontSize = 80.0,
  });

  @override
  State<AnimatedAppName> createState() => _AnimatedAppNameState();
}

class _AnimatedAppNameState extends State<AnimatedAppName>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 0.0, end: 8.0).animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.appName,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w900,
            color: const Color.fromARGB(255, 36, 35, 34),
            shadows: [
              Shadow(
                blurRadius: _animation.value * 3,
                color: const Color.fromARGB(255, 233, 176, 89),
                offset: Offset(_animation.value, _animation.value),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
