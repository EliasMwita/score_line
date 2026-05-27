import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoreline/features/scores/presentation/providers/scores_providers.dart';
import 'package:scoreline/shared/providers/navigation_provider.dart';
import 'package:scoreline/domain/models/event.dart';
import 'package:scoreline/shared/widgets/nav_bar.dart';
import 'package:scoreline/shared/widgets/bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/world_cup_section.dart';
import '../widgets/featured_matches.dart';
import '../widgets/match_card.dart';
import '../widgets/quick_stats.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  bool _showSearchField = false;
  bool _showFinished = true;
  late AnimationController _headerAnimController;
  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();

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
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scoresState = ref.watch(scoresNotifierProvider);
    final selectedNavIndex = ref.watch(navigationProvider);

    if (scoresState.isLoading) {
      return Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF4444)),
          ),
        ),
      );
    }

    if (scoresState.error != null) {
      return _buildErrorState(isDark, scoresState.error!);
    }

    return _buildMainContent(
        context, isDark, scoresState.matches, selectedNavIndex);
  }

  Widget _buildMainContent(BuildContext context, bool isDark,
      List<Event> events, int selectedNavIndex) {
    final worldCupMatches = events.where((e) => e.isWorldCup).toList();
    final regularMatches = events.where((e) => !e.isWorldCup).toList();

    final liveMatches = regularMatches
        .where((e) =>
            e.strStatus?.toLowerCase() == 'live' ||
            e.strStatus?.toLowerCase().contains('\'') == true)
        .toList();

    final finishedMatches = regularMatches.where((e) {
      final status = e.strStatus?.toLowerCase() ?? '';
      return status == 'match finished' ||
          status == 'ft' ||
          status == 'aet' ||
          status == 'penalties';
    }).toList();

    final upcomingMatches = regularMatches.where((e) {
      final status = e.strStatus?.toLowerCase() ?? '';
      final isLive = status == 'live' || status.contains('\'');
      final isFinished = status == 'match finished' ||
          status == 'ft' ||
          status == 'aet' ||
          status == 'penalties';
      return !isLive && !isFinished;
    }).toList();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
      extendBodyBehindAppBar: true,
      drawer: const NavBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          HomeHeader(
            title: widget.title,
            isDark: isDark,
            headerAnimController: _headerAnimController,
            pulseController: _pulseController,
            onSearchPressed: () =>
                setState(() => _showSearchField = !_showSearchField),
          ),

          // World Cup Section
          if (worldCupMatches.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: _buildMainEventBadge(worldCupMatches),
              ),
            ),
            SliverToBoxAdapter(
                child: WorldCupSection(
                    isDark: isDark, worldCupMatches: worldCupMatches)),
          ],

          if (liveMatches.isNotEmpty)
            SliverToBoxAdapter(
                child:
                    FeaturedMatches(liveMatches: liveMatches, isDark: isDark)),

          SliverToBoxAdapter(
              child: QuickStats(
                  isDark: isDark,
                  liveCount: liveMatches.length,
                  totalCount: events.length)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: _buildSectionHeader('LIVE MATCHES',
                  [const Color(0xFFEF4444), const Color(0xFFF97316)]),
            ),
          ),

          if (liveMatches.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => MatchCard(
                      event: liveMatches[index],
                      index: index,
                      isDark: isDark,
                      isLive: true),
                  childCount: liveMatches.length,
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              child: _buildSwitchHeader(),
            ),
          ),

          if (_showFinished)
            finishedMatches.isNotEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => MatchCard(
                            event: finishedMatches[index],
                            index: index,
                            isDark: isDark,
                            isLive: false),
                        childCount: finishedMatches.length,
                      ),
                    ),
                  )
                : const SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No finished matches"))))
          else
            upcomingMatches.isNotEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => MatchCard(
                            event: upcomingMatches[index],
                            index: index,
                            isDark: isDark,
                            isLive: false),
                        childCount: upcomingMatches.length,
                      ),
                    ),
                  )
                : const SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No upcoming matches")))),

          if (events.isEmpty)
            SliverFillRemaining(child: _buildEmptyState(isDark)),
        ],
      ),
      bottomNavigationBar:
          BottomNav(isDark: isDark, selectedNavIndex: selectedNavIndex),
    );
  }

  Widget _buildMainEventBadge(List<Event> matches) {
    final firstMatch = matches.isNotEmpty ? matches.first : null;
    final leagueName = firstMatch?.strLeague?.toUpperCase() ?? 'WORLD CUP';
    final season = firstMatch?.strSeason ?? '2026';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD946EF).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_events_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'MAIN EVENT: $leagueName $season',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showFinished = true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: _showFinished
                      ? const LinearGradient(
                          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)])
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FINISHED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: _showFinished
                        ? Colors.white
                        : (isDark ? Colors.white54 : Colors.black54),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showFinished = false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: !_showFinished
                      ? const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)])
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'UPCOMING',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: !_showFinished
                        ? Colors.white
                        : (isDark ? Colors.white54 : Colors.black54),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, List<Color> colors) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_soccer_outlined,
              size: 80,
              color: isDark ? Colors.white24 : const Color(0xFFD1D5DB)),
          const SizedBox(height: 24),
          const Text('No matches found',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70)),
          const SizedBox(height: 32),
          // Transfer Window Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TRANSFER WINDOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.swap_horizontal_circle,
                        color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Summer Transfer Window is now open! Track all official moves.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark, String error) {
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            const Text(
              'Error loading matches',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
