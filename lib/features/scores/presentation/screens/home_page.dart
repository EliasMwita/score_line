import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoreline/providers/scores_providers.dart';
import 'package:scoreline/domain/models/event.dart';
import 'package:scoreline/widgets/nav_bar.dart';
import 'event_detail_screen.dart';
import 'dart:ui';
import 'dart:math' as math;

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  bool _showSearchField = false;
  late AnimationController _headerAnimController;
  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();
  final PageController _featuredController = PageController(viewportFraction: 0.9);
  int _currentFeaturedIndex = 0;

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
    });
  }

  void _autoScrollFeatured(int totalMatches) {
    if (!mounted || totalMatches == 0) return;

    _currentFeaturedIndex = (_currentFeaturedIndex + 1) % totalMatches;
    _featuredController.animateToPage(
      _currentFeaturedIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );

    Future.delayed(const Duration(seconds: 5), () => _autoScrollFeatured(totalMatches));
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final liveScoresAsync = ref.watch(liveScoresStreamProvider);
    final selectedNavIndex = ref.watch(navigationProvider);

    return liveScoresAsync.when(
      loading: () => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF4444)),
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading matches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (events) => _buildMainContent(context, isDark, events, selectedNavIndex),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isDark, List<Event> events, int selectedNavIndex) {
    // Separate World Cup matches, live matches, and upcoming matches
    final worldCupMatches = events.where((e) => e.isWorldCup).toList();
    final regularMatches = events.where((e) => !e.isWorldCup).toList();

    final liveMatches = regularMatches
        .where((e) => e.strStatus?.toLowerCase() == 'live' || e.strStatus?.toLowerCase().contains('\'') == true)
        .toList();
    final upcomingMatches = regularMatches
        .where((e) => e.strStatus?.toLowerCase() != 'live' && e.strStatus?.toLowerCase().contains('\'') != true)
        .toList();

    // Start auto-scroll if there are live matches
    if (liveMatches.isNotEmpty && _currentFeaturedIndex == 0) {
      Future.delayed(const Duration(seconds: 3), () => _autoScrollFeatured(liveMatches.length));
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Animated gradient header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark
                ? const Color(0xFF1E293B).withOpacity(0.9)
                : Colors.white.withOpacity(0.9),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: Colors.white, size: 20),
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
                  child: const Icon(Icons.search, color: Colors.white, size: 20),
                ),
                onPressed: () => setState(() => _showSearchField = !_showSearchField),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Animated gradient
                  AnimatedBuilder(
                    animation: _headerAnimController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.lerp(
                                const Color(0xFFEF4444),
                                const Color(0xFFF97316),
                                _headerAnimController.value,
                              )!,
                              Color.lerp(
                                const Color(0xFFF97316),
                                const Color(0xFFEF4444),
                                _headerAnimController.value,
                              )!,
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Orbs
                  AnimatedBuilder(
                    animation: _headerAnimController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _OrbsPainter(progress: _headerAnimController.value),
                      );
                    },
                  ),

                  // Content
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.sports_soccer_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
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
                                      const Text(
                                        'Live Matches & Scores',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // World Cup 2026 Section
          if (worldCupMatches.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _buildWorldCupSection(isDark, worldCupMatches),
            ),
          ],

          // Featured matches carousel
          if (liveMatches.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildFeaturedMatches(isDark, liveMatches),
            ),

          // Quick stats
          SliverToBoxAdapter(
            child: _buildQuickStats(isDark, liveMatches.length, events.length),
          ),

          // Live matches section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'LIVE MATCHES',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withOpacity(
                                      0.5 + (_pulseController.value * 0.5),
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Live match cards
          if (liveMatches.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildMatchCardFromEvent(liveMatches[index], index, isDark, true);
                  },
                  childCount: liveMatches.length,
                ),
              ),
            ),

          // Upcoming matches
          if (upcomingMatches.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'UPCOMING',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildMatchCardFromEvent(upcomingMatches[index], index, isDark, false);
                  },
                  childCount: upcomingMatches.length,
                ),
              ),
            ),
          ],

          // Empty state
          if (events.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFEF4444).withOpacity(0.1),
                            const Color(0xFFF97316).withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sports_soccer_outlined,
                        size: 80,
                        color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No matches found',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for live scores',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // Modern bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.sports_soccer_rounded, 'Scores', isDark, selectedNavIndex),
                _buildNavItem(1, Icons.favorite_rounded, 'Favorites', isDark, selectedNavIndex),
                _buildNavItem(2, Icons.play_circle_filled, 'Watch', isDark, selectedNavIndex),
                _buildNavItem(3, Icons.person_rounded, 'Profile', isDark, selectedNavIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark, int selectedNavIndex) {
    final isSelected = selectedNavIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(navigationProvider.notifier).setIndex(index);
        if (index == 0) context.go('/');
        if (index == 1) context.go('/Favourites');
        if (index == 2) context.go('/Watch');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white38
                      : const Color(0xFF9CA3AF),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedMatches(bool isDark, List<Event> liveMatches) {
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
              itemCount: liveMatches.length,
              itemBuilder: (context, index) {
                final event = liveMatches[index];
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
                  child: _buildFeaturedCardFromEvent(event, isDark),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              liveMatches.length,
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
                      : isDark
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

  Widget _buildFeaturedCardFromEvent(Event event, bool isDark) {
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
                    // Home team
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
                    // Score
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
                    // Away team
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

  Widget _buildMatchCardFromEvent(Event event, int index, bool isDark, bool isLive) {
    final homeScore = event.intHomeScore;
    final awayScore = event.intAwayScore;
    final time = event.strProgress ?? event.strTime;
    final competition = event.strLeague;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(event: event),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Competition and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.sports_soccer,
                              size: 14,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            competition ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFEF4444).withOpacity(
                                            0.5 + (_pulseController.value * 0.5),
                                          ),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              Text(
                                time ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          time ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Teams and score
                  Row(
                    children: [
                      // Home team
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: event.strHomeTeamBadge.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: event.strHomeTeamBadge,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => const Icon(
                                          Icons.sports_soccer,
                                          color: Color(0xFF3B82F6),
                                          size: 24,
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.sports_soccer,
                                          color: Color(0xFF3B82F6),
                                          size: 24,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.sports_soccer,
                                        color: Color(0xFF3B82F6),
                                        size: 24,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                event.strHomeTeam,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Score
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isLive
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFEF4444),
                                    Color(0xFFF97316)
                                  ],
                                )
                              : null,
                          color: isLive
                              ? null
                              : isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isLive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          '$homeScore : $awayScore',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isLive
                                ? Colors.white
                                : isDark
                                    ? Colors.white70
                                    : const Color(0xFF6B7280),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Away team
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.strAwayTeam,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.sports_soccer,
                                color: Color(0xFFF97316),
                                size: 24,
                              ),
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


  Widget _buildQuickStats(bool isDark, int liveCount, int totalCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.live_tv_rounded,
              label: 'Live Now',
              value: '$liveCount',
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFF97316)],
              ),
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.upcoming_rounded,
              label: 'Today',
              value: '$totalCount',
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
              ),
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite_rounded,
              label: 'Favorites',
              value: '8',
              gradient: const LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFFF97316)],
              ),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldCupSection(bool isDark, List<Event> worldCupMatches) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // World Cup header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD946EF).withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FIFA WORLD CUP 2026',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white70, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'USA, Canada, Mexico',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // World Cup matches
          ...worldCupMatches.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            final isLive = event.strStatus?.toLowerCase() == 'live' ||
                event.strStatus?.toLowerCase().contains('\'') == true;

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFD946EF).withOpacity(0.1),
                      const Color(0xFF8B5CF6).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFD946EF).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD946EF).withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(event: event),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Status and venue
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    event.strVenue ?? 'Stadium',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                              if (isLive)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFD946EF).withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      AnimatedBuilder(
                                        animation: _pulseController,
                                        builder: (context, child) {
                                          return Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(
                                                    0.5 + (_pulseController.value * 0.5),
                                                  ),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        event.strProgress ?? 'LIVE',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Text(
                                  event.strTime ?? 'TBD',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Teams and score
                          Row(
                            children: [
                              // Home team
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: event.strHomeTeamBadge.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: event.strHomeTeamBadge,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) => const Icon(
                                                  Icons.sports_soccer,
                                                  size: 28,
                                                ),
                                                errorWidget: (context, url, error) => const Icon(
                                                  Icons.sports_soccer,
                                                  size: 28,
                                                ),
                                              )
                                            : const Icon(Icons.sports_soccer, size: 28),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        event.strHomeTeam,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF111827),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Score
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: isLive
                                      ? const LinearGradient(
                                          colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
                                        )
                                      : null,
                                  color: isLive
                                      ? null
                                      : isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: isLive
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFD946EF).withOpacity(0.4),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  '${event.intHomeScore} : ${event.intAwayScore}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: isLive
                                        ? Colors.white
                                        : isDark
                                            ? Colors.white70
                                            : const Color(0xFF6B7280),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Away team
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event.strAwayTeam,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF111827),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: event.strAwayTeamBadge.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: event.strAwayTeamBadge,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) => const Icon(
                                                  Icons.sports_soccer,
                                                  size: 28,
                                                ),
                                                errorWidget: (context, url, error) => const Icon(
                                                  Icons.sports_soccer,
                                                  size: 28,
                                                ),
                                              )
                                            : const Icon(Icons.sports_soccer, size: 28),
                                      ),
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
          }).toList(),
        ],
      ),
    );
  }
}

// Orbs painter
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
