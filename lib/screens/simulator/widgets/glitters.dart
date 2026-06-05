
import 'dart:math';
import 'package:flutter/material.dart';

class CyberGlitters extends StatefulWidget {
  final int particleCount;

  const CyberGlitters({
    super.key, 
    this.particleCount = 20, // Adjust this to add more or fewer glitters
  });

  @override
  State<CyberGlitters> createState() => _CyberGlittersState();
}

class _CyberGlittersState extends State<CyberGlitters> with SingleTickerProviderStateMixin {
 late AnimationController _controller;
  List<GlitterParticle> _particles = []; // ✅ Fix: Initialize as an empty list!
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // Speed of the twinkling
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeParticles(Size size) {
    _particles = List.generate(widget.particleCount, (index) {
      // Randomly assign Neon Cyan or Neon Red
      Color color = _random.nextBool() ? Colors.cyanAccent : Colors.redAccent;
      
      return GlitterParticle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        size: _random.nextDouble() * 1.75 + 1.75, // Size between 1.0 and 3.5
        color: color,
        // Give each particle a random starting phase so they don't blink together
        phase: _random.nextDouble() * 2 * pi, 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Initialize particles only once based on screen size
        if (_particles.isEmpty || 
            _particles.first.x > constraints.maxWidth || 
            _particles.first.y > constraints.maxHeight) {
          _initializeParticles(Size(constraints.maxWidth, constraints.maxHeight));
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: GlitterPainter(
                particles: _particles,
                animationValue: _controller.value,
              ),
            );
          },
        );
      },
    );
  }
}

// --- THE PAINTER ---
class GlitterPainter extends CustomPainter {
  final List<GlitterParticle> particles;
  final double animationValue;

  GlitterPainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Calculate opacity using a sine wave for smooth fading in and out
      double opacity = (sin((animationValue * 2 * pi) + particle.phase) + 1) / 2;
      
      // The glowing paint
      final Paint paint = Paint()
        ..color = particle.color.withOpacity(opacity * 0.8) // Max opacity is 80%
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0); // Adds the neon glow

      // The bright core paint
      final Paint corePaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw glow
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size * 1.5, paint);
      // Draw white hot core
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size * 0.4, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant GlitterPainter oldDelegate) => true;
}

// --- DATA CLASS ---
class GlitterParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double phase;

  GlitterParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.phase,
  });
}