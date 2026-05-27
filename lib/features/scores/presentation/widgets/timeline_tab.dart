import 'package:flutter/material.dart';
import '../../../../domain/models/event.dart';

class TimelineTab extends StatelessWidget {
  final Event event;
  final bool isDark;

  const TimelineTab({
    super.key,
    required this.event,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (event.events.isEmpty) {
      return _buildEmptyState(
        isDark,
        Icons.timeline,
        'No events yet',
        'Match events will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: event.events.length,
      itemBuilder: (context, index) {
        final matchEvent = event.events[index];
        final isHome = matchEvent.team == event.strHomeTeam;

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
                        gradient: _getEventGradient(matchEvent.type),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getEventColor(matchEvent.type).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getEventIcon(matchEvent.type),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    if (index < event.events.length - 1)
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
                              matchEvent.player,
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
                                color: _getEventColor(matchEvent.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                matchEvent.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: _getEventColor(matchEvent.type),
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
                                matchEvent.team,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isHome ? const Color(0xFF3B82F6) : const Color(0xFFF97316),
                                ),
                              ),
                            ),
                            if (matchEvent.assist != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Assist: ${matchEvent.assist}',
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
