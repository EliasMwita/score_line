import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../../../domain/models/event.dart';
import '../screens/event_detail_screen.dart';

class FeaturedMatches extends StatefulWidget {
  final List<Event> liveMatches;
  final bool isDark;

  const FeaturedMatches({
    super.key,
    required this.liveMatches,
    required this.isDark,
  });

  @override
  State<FeaturedMatches> createState() => _FeaturedMatchesState();
}

class _FeaturedMatchesState extends State<FeaturedMatches> with SingleTickerProviderStateMixin {
  late PageController _featuredController;
  late AnimationController _pulseController;
  int _currentFeaturedIndex = 0;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.9);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Auto-scroll logic if matches exist
    if (widget.liveMatches.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      _currentFeaturedIndex = (_currentFeaturedIndex + 1) % widget.liveMatches.length;
      _featuredController.animateToPage(
        _currentFeaturedIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _featuredController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.liveMatches.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _featuredController,
              onPageChanged: (index) {
                setState(() => _currentFeaturedIndex = index);
              },
              itemCount: widget.liveMatches.length,
              itemBuilder: (context, index) {
                final event = widget.liveMatches[index];
                return AnimatedBuilder(
                  animation: _featuredController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_featuredController.position.haveDimensions) {
                      value = _featuredController.page! - index;
                      value = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
                    }
                    return Center(
                      child: Transform.scale(
                        scale: value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildFeaturedCard(event),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.liveMatches.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentFeaturedIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: _currentFeaturedIndex == index
                      ? const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                        )
                      : null,
                  color: _currentFeaturedIndex == index
                      ? null
                      : widget.isDark
                          ? Colors.white24
                          : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Event event) {
    final homeScore = event.intHomeScore;
    final awayScore = event.intAwayScore;
    final status = event.strStatus;
    final time = event.strProgress ?? event.strTime;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFEF4444).withOpacity(0.9),
              const Color(0xFFF97316).withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
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
                                    0.5 + (_pulseController.value * 0.5),
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
                        '$status${(time?.isNotEmpty ?? false) ? " • $time" : ""}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: event.strHomeTeamBadge.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: event.strHomeTeamBadge,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => const Icon(
                                          Icons.sports_soccer,
                                          color: Color(0xFFEF4444),
                                          size: 30,
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.sports_soccer,
                                          color: Color(0xFFEF4444),
                                          size: 30,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.sports_soccer,
                                        color: Color(0xFFEF4444),
                                        size: 30,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.strHomeTeam,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '$homeScore : $awayScore',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFEF4444),
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: event.strAwayTeamBadge.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: event.strAwayTeamBadge,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => const Icon(
                                          Icons.sports_soccer,
                                          color: Color(0xFFF97316),
                                          size: 30,
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.sports_soccer,
                                          color: Color(0xFFF97316),
                                          size: 30,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.sports_soccer,
                                        color: Color(0xFFF97316),
                                        size: 30,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.strAwayTeam,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
