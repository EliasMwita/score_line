import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/models/event.dart';
import 'dart:math' as math;

class DetailHeader extends StatelessWidget {
  final Event event;
  final AnimationController headerController;
  final AnimationController pulseController;
  final bool isDark;

  const DetailHeader({
    super.key,
    required this.event,
    required this.headerController,
    required this.pulseController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = event.strStatus?.toLowerCase() == 'live' ||
        event.strStatus?.toLowerCase().contains('\'') == true;

    return SliverAppBar(
      expandedHeight: event.isWorldCup ? 280 : 240,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark
          ? const Color(0xFF1E293B).withOpacity(0.9)
          : Colors.white.withOpacity(0.9),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.share, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Animated gradient background
            AnimatedBuilder(
              animation: headerController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: event.isWorldCup
                          ? [
                              Color.lerp(
                                const Color(0xFFD946EF),
                                const Color(0xFF8B5CF6),
                                headerController.value,
                              )!,
                              Color.lerp(
                                const Color(0xFF8B5CF6),
                                const Color(0xFFD946EF),
                                headerController.value,
                              )!,
                            ]
                          : [
                              Color.lerp(
                                const Color(0xFFEF4444),
                                const Color(0xFFF97316),
                                headerController.value,
                              )!,
                              Color.lerp(
                                const Color(0xFFF97316),
                                const Color(0xFFEF4444),
                                headerController.value,
                              )!,
                            ],
                    ),
                  ),
                );
              },
            ),

            // Orbs
            AnimatedBuilder(
              animation: headerController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _OrbsPainter(progress: headerController.value),
                );
              },
            ),

            // World Cup badge
            if (event.isWorldCup)
              Positioned(
                top: 70,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.5),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'FIFA WORLD CUP 2026',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Match details
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Status and time
                  if (isLive)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                      0.5 + (pulseController.value * 0.5),
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.strProgress ?? 'LIVE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      event.strTime ?? 'Scheduled',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Teams and score
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Home team
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: event.strHomeTeamBadge.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: event.strHomeTeamBadge,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => const Icon(
                                            Icons.sports_soccer,
                                            size: 40,
                                          ),
                                          errorWidget: (context, url, error) => const Icon(
                                            Icons.sports_soccer,
                                            size: 40,
                                          ),
                                        )
                                      : const Icon(Icons.sports_soccer, size: 40),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                event.strHomeTeam,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Score
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            '${event.intHomeScore} : ${event.intAwayScore}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: event.isWorldCup
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFFEF4444),
                              letterSpacing: -1,
                            ),
                          ),
                        ),

                        // Away team
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: event.strAwayTeamBadge.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: event.strAwayTeamBadge,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => const Icon(
                                            Icons.sports_soccer,
                                            size: 40,
                                          ),
                                          errorWidget: (context, url, error) => const Icon(
                                            Icons.sports_soccer,
                                            size: 40,
                                          ),
                                        )
                                      : const Icon(Icons.sports_soccer, size: 40),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                event.strAwayTeam,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbsPainter extends CustomPainter {
  final double progress;

  _OrbsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    paint.color = Colors.white.withOpacity(0.15);
    canvas.drawCircle(
      Offset(
        size.width * (0.2 + 0.3 * math.sin(progress * 2 * math.pi)),
        size.height * (0.3 + 0.2 * math.cos(progress * 2 * math.pi)),
      ),
      60,
      paint,
    );

    paint.color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(
      Offset(
        size.width * (0.7 + 0.2 * math.cos(progress * 2 * math.pi + 1)),
        size.height * (0.5 + 0.3 * math.sin(progress * 2 * math.pi + 1)),
      ),
      70,
      paint,
    );
  }

  @override
  bool shouldRepaint(_OrbsPainter oldDelegate) => true;
}
