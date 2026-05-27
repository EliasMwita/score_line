import 'package:flutter/material.dart';

class StatsTab extends StatelessWidget {
  final bool isDark;

  const StatsTab({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
}
