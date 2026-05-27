import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/navigation_provider.dart';
import '../../../../shared/widgets/nav_bar.dart';
import '../../../../shared/widgets/bottom_nav.dart';

class Watch extends ConsumerStatefulWidget {
  const Watch({super.key, required this.title});
  final String title;

  @override
  ConsumerState<Watch> createState() => _WatchState();
}

class _WatchState extends ConsumerState<Watch> {
  bool _showSearchField = false;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black26,
      drawer: const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => setState(() => _showSearchField = true),
          ),
        ],
        title: _showSearchField ? const SearchField() : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.black54,
          child: const Column(
            children: [
              Row(
                children: [
                  Text("Watch", style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 40),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(isDark: isDark, selectedNavIndex: selectedIndex),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
