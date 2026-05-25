import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFF97316)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.sports_soccer_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sports Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Live Scores & Updates',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Color(0xFFEF4444)),
            title: Text(
              'Home',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_rounded, color: Color(0xFFEF4444)),
            title: Text(
              'Favorites',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded, color: Color(0xFFEF4444)),
            title: Text(
              'Settings',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
