import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SoccerSplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SoccerSplashScreen({super.key, required this.onComplete});

  @override
  State<SoccerSplashScreen> createState() => _SoccerSplashScreenState();
}

class _SoccerSplashScreenState extends State<SoccerSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ballController;
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;

  late Animation<double> _ballAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _progress = 0.0;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // Ball bounce animation
    _ballController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _ballAnimation = Tween<double>(begin: 0.0, end: -80.0).animate(
      CurvedAnimation(
        parent: _ballController,
        curve: Curves.easeInOut,
      ),
    );

    // Ball rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _rotationController,
    );

    // Fade in animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Shimmer animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Show text after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showText = true);
      }
    });

    // Progress animation
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _progress += 2.5;
        if (_progress >= 100) {
          _progress = 100;
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              widget.onComplete();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _ballController.dispose();
    _rotationController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Dark blue
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated field lines
            CustomPaint(
              size: Size.infinite,
              painter: _FieldPainter(),
            ),

            // Shimmer effect
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ShimmerPainter(progress: _shimmerController.value),
                );
              },
            ),

            // Floating particles
            ...List.generate(15, (index) {
              return _buildFloatingParticle(index);
            }),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouncing soccer ball with rotation
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _ballAnimation,
                        _rotationAnimation,
                        _scaleAnimation,
                      ]),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _ballAnimation.value),
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFFE5E7EB),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF4444).withOpacity(0.6),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                  painter: _SoccerBallPainter(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 60),

                    // App name with animation
                    if (_showText)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFFEF4444),
                                    Color(0xFFF97316),
                                    Color(0xFFEF4444),
                                  ],
                                ).createShader(bounds);
                              },
                              child: const Text(
                                'SCORELINE',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.emoji_events, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'LIVE FOOTBALL UPDATES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 50),

                    // Tagline
                    if (_showText)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: child,
                          );
                        },
                        child: Text(
                          'Live Scores • Match Updates • Stats',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const SizedBox(height: 60),

                    // Modern progress indicator
                    Container(
                      width: 280,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progress / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                                ),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withOpacity(0.6),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Loading text with percentage
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return Text(
                          'Loading ${_progress.toInt()}%',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom branding
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, Color(0xFFEF4444)],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.sports_soccer,
                          color: Colors.white.withOpacity(0.4),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 30,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Colors.transparent],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Powered by Sports Data API',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final startX = random.nextDouble() * MediaQuery.of(context).size.width;
    final startY = random.nextDouble() * MediaQuery.of(context).size.height;
    final duration = 3000 + random.nextInt(2000);

    return Positioned(
      left: startX,
      top: startY,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: duration),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(value * 2 * math.pi) * 20,
              -value * 100,
            ),
            child: Opacity(
              opacity: (1 - value) * 0.6,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onEnd: () {
          if (mounted) {
            setState(() {
              // Restart animation
            });
          }
        },
      ),
    );
  }
}

// Soccer ball painter
class _SoccerBallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw pentagon pattern
    final pentagonRadius = radius * 0.3;
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - math.pi / 2;
      final x = center.dx + pentagonRadius * math.cos(angle);
      final y = center.dy + pentagonRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Draw hexagon patterns around
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - math.pi / 2;
      final hexX = center.dx + radius * 0.5 * math.cos(angle);
      final hexY = center.dy + radius * 0.5 * math.sin(angle);

      final hexPath = Path();
      for (int j = 0; j < 3; j++) {
        final hexAngle = angle + (j * 2 * math.pi / 6);
        final x = hexX + radius * 0.15 * math.cos(hexAngle);
        final y = hexY + radius * 0.15 * math.sin(hexAngle);

        if (j == 0) {
          hexPath.moveTo(x, y);
        } else {
          hexPath.lineTo(x, y);
        }
      }
      hexPath.close();
      canvas.drawPath(hexPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Field lines painter
class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.05);

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      100,
      paint,
    );

    // Horizontal lines
    for (int i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Vertical lines
    for (int i = 0; i < 6; i++) {
      final x = (size.width / 6) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Shimmer effect painter
class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.05),
          Colors.transparent,
        ],
        stops: [
          progress - 0.3,
          progress,
          progress + 0.3,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
