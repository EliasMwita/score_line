import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';

class BottomNav extends ConsumerWidget {
  final bool isDark;
  final int selectedNavIndex;

  const BottomNav({
    super.key,
    required this.isDark,
    required this.selectedNavIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
              _buildNavItem(context, ref, 0, Icons.sports_soccer_rounded, 'Scores'),
              _buildNavItem(context, ref, 1, Icons.favorite_rounded, 'Favorites'),
              _buildNavItem(context, ref, 2, Icons.play_circle_filled, 'Watch'),
              _buildNavItem(context, ref, 3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, int index, IconData icon, String label) {
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
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFF97316)])
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
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
}
