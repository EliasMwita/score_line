import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoreline/providers/scores_providers.dart';
import 'package:scoreline/widgets/nav_bar.dart';

class Watch extends ConsumerStatefulWidget {
  const Watch({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<Watch> createState() => _WatchState();
}

class _WatchState extends ConsumerState<Watch> {
  bool _showSearchField = false;

  @override
  Widget build(BuildContext context) {

    final selectedIndex = ref.watch(navigationProvider);

    return Scaffold(
      backgroundColor: Colors.black26,
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _showSearchField = true;
              });
            },
          ),
        ],
        title: _showSearchField
            ? SearchField()
            : null,
      ),
      body: SingleChildScrollView(
        // Set background color here
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.black54,
          child: const Column(
            children: [
              Row(
                children: [
                  Text("Watch", style: TextStyle(color: Colors.white, fontSize: 20),),
                  Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 40,)

                ],
              )
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.09,
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.orange,
          tabBackgroundColor: Colors.black,
          gap: 9,
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            ref.read(navigationProvider.notifier).setIndex(index);
            if (index == 0) {
              context.go('/');
            } else if (index == 1) {
              context.go('/Favourites');
            } else if (index == 2) {
              context.go('/Watch');
            } else if (index == 3) {
              setState(() {
              });
            }
          },
          tabs: const [
            GButton(
              icon: Icons.sports_baseball,
              text: 'Scores',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Favourites',
            ),
            GButton(
              icon: Icons.play_circle_fill,
              text: 'Watch',
            ),
            GButton(
              icon: Icons.refresh,
              text: 'Refresh',
            ),
          ],
        ),
      ),

    );
  }
}

class SearchField extends StatelessWidget {
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
