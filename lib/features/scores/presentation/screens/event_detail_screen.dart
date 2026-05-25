import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoreline/domain/models/event.dart';
import 'package:scoreline/domain/models/player.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _pulseController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _pulseController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLive = widget.event.strStatus?.toLowerCase() == 'live' ||
        widget.event.strStatus?.toLowerCase().contains('\'') == true;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          // Impressive header
          SliverAppBar(
            expandedHeight: widget.event.isWorldCup ? 280 : 240,
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
                    animation: _headerController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: widget.event.isWorldCup
                                ? [
                                    Color.lerp(
                                      const Color(0xFFD946EF),
                                      const Color(0xFF8B5CF6),
                                      _headerController.value,
                                    )!,
                                    Color.lerp(
                                      const Color(0xFF8B5CF6),
                                      const Color(0xFFD946EF),
                                      _headerController.value,
                                    )!,
                                  ]
                                : [
                                    Color.lerp(
                                      const Color(0xFFEF4444),
                                      const Color(0xFFF97316),
                                      _headerController.value,
                                    )!,
                                    Color.lerp(
                                      const Color(0xFFF97316),
                                      const Color(0xFFEF4444),
                                      _headerController.value,
                                    )!,
                                  ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Orbs
                  AnimatedBuilder(
                    animation: _headerController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _OrbsPainter(progress: _headerController.value),
                      );
                    },
                  ),

                  // World Cup badge
                  if (widget.event.isWorldCup)
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              const Text(
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
                                widget.event.strProgress ?? 'LIVE',
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
                            widget.event.strTime ?? 'Scheduled',
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
                                        child: widget.event.strHomeTeamBadge.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: widget.event.strHomeTeamBadge,
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
                                      widget.event.strHomeTeam,
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
                                  '${widget.event.intHomeScore} : ${widget.event.intAwayScore}',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: widget.event.isWorldCup
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
                                        child: widget.event.strAwayTeamBadge.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: widget.event.strAwayTeamBadge,
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
                                      widget.event.strAwayTeam,
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
          ),

          // Competition and venue info
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.event.isWorldCup
                                ? [const Color(0xFFD946EF), const Color(0xFF8B5CF6)]
                                : [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.sports_soccer, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.event.strLeague ?? 'Unknown League',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.event.strVenue != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.event.strVenue!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                indicatorColor: widget.event.isWorldCup
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFFEF4444),
                indicatorWeight: 3,
                labelColor: isDark ? Colors.white : const Color(0xFF111827),
                unselectedLabelColor: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'TIMELINE'),
                  Tab(text: 'LINEUPS'),
                  Tab(text: 'STATS'),
                ],
              ),
              isDark: isDark,
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTimelineTab(isDark),
                _buildLineupsTab(isDark),
                _buildStatsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(bool isDark) {
    if (widget.event.events.isEmpty) {
      return _buildEmptyState(
        isDark,
        Icons.timeline,
        'No events yet',
        'Match events will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.event.events.length,
      itemBuilder: (context, index) {
        final event = widget.event.events[index];
        final isHome = event.team == widget.event.strHomeTeam;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                // Timeline line
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: _getEventGradient(event.type),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getEventColor(event.type).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getEventIcon(event.type),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    if (index < widget.event.events.length - 1)
                      Container(
                        width: 2,
                        height: 40,
                        color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Event details
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              event.player,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF111827),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getEventColor(event.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                event.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: _getEventColor(event.type),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isHome
                                    ? const Color(0xFF3B82F6).withOpacity(0.1)
                                    : const Color(0xFFF97316).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                event.team,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isHome ? const Color(0xFF3B82F6) : const Color(0xFFF97316),
                                ),
                              ),
                            ),
                            if (event.assist != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Assist: ${event.assist}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineupsTab(bool isDark) {
    if (widget.event.homeLineup.isEmpty && widget.event.awayLineup.isEmpty) {
      return _buildEmptyState(
        isDark,
        Icons.groups,
        'Lineups not available',
        'Team lineups will be shown here',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Home team lineup
          _buildTeamLineup(
            widget.event.strHomeTeam,
            widget.event.homeLineup,
            const Color(0xFF3B82F6),
            isDark,
          ),
          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white54 : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),

          // Away team lineup
          _buildTeamLineup(
            widget.event.strAwayTeam,
            widget.event.awayLineup,
            const Color(0xFFF97316),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLineup(String teamName, List<Player> lineup, Color color, bool isDark) {
    final grouped = <String, List<Player>>{};
    for (final player in lineup) {
      grouped.putIfAbsent(player.position ?? 'Unknown', () => []).add(player);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.shield, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                teamName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Players by position
          ...grouped.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ...entry.value.map((player) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (player.number != null) ...[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withOpacity(0.7)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                player.number!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          player.strPlayer,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStatBar('Possession', 52, 48, isDark),
          const SizedBox(height: 16),
          _buildStatBar('Shots on Target', 7, 5, isDark),
          const SizedBox(height: 16),
          _buildStatBar('Total Shots', 14, 11, isDark),
          const SizedBox(height: 16),
          _buildStatBar('Corners', 6, 4, isDark),
          const SizedBox(height: 16),
          _buildStatBar('Fouls', 9, 12, isDark),
          const SizedBox(height: 16),
          _buildStatBar('Yellow Cards', 2, 3, isDark),
          const SizedBox(height: 16),
          _buildStatBar('Pass Accuracy', 84, 79, isDark),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int home, int away, bool isDark) {
    final total = home + away;
    final homePercent = total > 0 ? home / total : 0.5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$home',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3B82F6),
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                ),
              ),
              Text(
                '$away',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF97316),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: (homePercent * 100).round(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: ((1 - homePercent) * 100).round(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String type) {
    switch (type.toLowerCase()) {
      case 'goal':
        return Icons.sports_soccer;
      case 'card':
        return Icons.rectangle;
      case 'substitution':
        return Icons.swap_horiz;
      default:
        return Icons.sports;
    }
  }

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'goal':
        return const Color(0xFF22C55E);
      case 'card':
        return const Color(0xFFEF4444);
      case 'substitution':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  LinearGradient _getEventGradient(String type) {
    switch (type.toLowerCase()) {
      case 'goal':
        return const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF10B981)],
        );
      case 'card':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        );
      case 'substitution':
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)],
        );
    }
  }
}

// Sticky tab bar delegate
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _StickyTabBarDelegate({required this.tabBar, required this.isDark});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
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
