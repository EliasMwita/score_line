import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/navigation_provider.dart';
import '../providers/favourites_providers.dart';
import '../../../../shared/widgets/nav_bar.dart';
import '../../../../shared/widgets/bottom_nav.dart';

class Favourites extends ConsumerStatefulWidget {
  const Favourites({super.key, required this.title});
  final String title;

  @override
  ConsumerState<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends ConsumerState<Favourites> {
  bool _showSearchField = false;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationProvider);
    final playersAsync = ref.watch(searchPlayersProvider('messi'));
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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Favourites", style: TextStyle(color: Colors.white, fontSize: 20)),
                    Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 40),
                  ],
                ),
              ),
              playersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
                error: (error, stack) => Center(child: Text('Error: $error', style: const TextStyle(color: Colors.white))),
                data: (players) {
                  if (players.isEmpty) {
                    return const Center(child: Text('No players found', style: TextStyle(color: Colors.white)));
                  }

                  final playersWithImages = players.where((player) => player.strThumb != null && player.strThumb!.isNotEmpty).toList();
                  final playersToShow = playersWithImages.length > 8 ? playersWithImages.sublist(0, 8) : playersWithImages;

                  return carousel_slider.CarouselSlider(
                    options: carousel_slider.CarouselOptions(
                      height: 250.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                    items: playersToShow.map((player) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: const BoxDecoration(color: Colors.black),
                            child: Column(
                              children: [
                                Expanded(child: Image.network(player.strThumb!, fit: BoxFit.cover)),
                                Text(player.strPlayer, style: const TextStyle(fontSize: 16.0, color: Colors.white)),
                                Text(player.strTeam, style: const TextStyle(fontSize: 12.0, color: Colors.white70)),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
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
