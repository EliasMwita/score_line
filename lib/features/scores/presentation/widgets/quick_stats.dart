import 'package:flutter/material.dart';

class QuickStats extends StatelessWidget {
  final bool isDark;
  final int liveCount;
  final int totalCount;

  const QuickStats({
    super.key,
    required this.isDark,
    required this.liveCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: [
          _buildStatCard('Live', liveCount.toString(), Icons.sensors, const Color(0xFFEF4444), isDark),
          const SizedBox(width: 12),
          _buildStatCard('Total', totalCount.toString(), Icons.format_list_bulleted_rounded, const Color(0xFF3B82F6), isDark),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF111827))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
