import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A snowflake particle with position, speed, and size properties.
class _Snowflake {
  double x;
  double y;
  final double radius;
  final double speed;
  final double drift;
  final double opacity;

  _Snowflake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.drift,
    required this.opacity,
  });
}

/// Animated falling snow overlay widget.
///
/// Renders snowflakes that drift downward with subtle horizontal movement.
/// Uses a single [AnimationController] for efficient rendering.
class AnimatedSnow extends StatefulWidget {
  /// Number of snowflakes to render.
  final int snowflakeCount;

  /// Overall opacity of the snow effect.
  final double opacity;

  const AnimatedSnow({super.key, this.snowflakeCount = 60, this.opacity = 0.6});

  @override
  State<AnimatedSnow> createState() => _AnimatedSnowState();
}

class _AnimatedSnowState extends State<AnimatedSnow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Snowflake> _snowflakes;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _snowflakes = _generateSnowflakes();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  List<_Snowflake> _generateSnowflakes() {
    return List.generate(widget.snowflakeCount, (_) {
      return _Snowflake(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.003 + 0.001,
        drift: (_random.nextDouble() - 0.5) * 0.002,
        opacity: _random.nextDouble() * 0.6 + 0.4,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update snowflake positions
        for (final flake in _snowflakes) {
          flake.y += flake.speed;
          flake.x += flake.drift;

          // Reset snowflake when it goes below the screen
          if (flake.y > 1.0) {
            flake.y = -0.05;
            flake.x = _random.nextDouble();
          }

          // Wrap horizontally
          if (flake.x > 1.0) flake.x = 0.0;
          if (flake.x < 0.0) flake.x = 1.0;
        }

        return Opacity(
          opacity: widget.opacity,
          child: CustomPaint(
            painter: _SnowPainter(snowflakes: _snowflakes),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _SnowPainter extends CustomPainter {
  final List<_Snowflake> snowflakes;

  _SnowPainter({required this.snowflakes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final flake in snowflakes) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: flake.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(flake.x * size.width, flake.y * size.height),
        flake.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SnowPainter oldDelegate) => true;
}
