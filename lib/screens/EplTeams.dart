import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../classes/epl_team.dart';
import 'nav_bar.dart';

class EPLTeams extends StatefulWidget {
  const EPLTeams({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<EPLTeams> createState() => _EPLTeamsState();
}

class _EPLTeamsState extends State<EPLTeams> {
  bool _showSearchField = false;
  List<EPLTeam> _teams = [];
  List<EPLTeam> _filteredTeams = [];

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    try {
      List<EPLTeam> teams = await fetchEPLTeams();
      setState(() {
        _teams = teams;
        _filteredTeams = teams;
      });
    } catch (e) {
      print(e);
    }
  }

  void _filterTeams(String query) {
    final filteredTeams = _teams.where((team) {
      final teamNameLower = team.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return teamNameLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredTeams = filteredTeams;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ? SearchField(
          onChanged: _filterTeams,
        )
            : null,
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.09,
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.orange,
          tabBackgroundColor: Colors.black,
          gap: 9,
          tabs: [
            GButton(
              icon: Icons.sports_baseball,
              onPressed: () {
                context.go('/');
              },
              text: 'Scores',
            ),
            GButton(
              icon: Icons.favorite,
              onPressed: () {
                context.go('/Favourites');
              },
              text: 'Favourites',
            ),
            GButton(
              icon: Icons.play_circle_fill,
              onPressed: () {
                context.go('/Watch');

              },
              text: 'Watch',
            ),
            GButton(
              icon: Icons.refresh,
              onPressed: () {},
              text: 'Refresh',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_teams.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _filteredTeams.length,
        itemBuilder: (context, index) {
          final team = _filteredTeams[index];
          return ListTile(
            leading: team.logoUrl.isNotEmpty
                ? Image.network(
              team.logoUrl,
              width: 50,
              height: 50,
            )
                : null,
            title: Text(
              team.name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stadium: ${team.stadium}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Row(
                  children: [
                    team.jerseyUrl.isNotEmpty
                        ? Image.network(
                      team.jerseyUrl,
                      width: 50,
                      height: 50,
                    )
                        : Container(),
                    team.teamLogoUrl.isNotEmpty
                        ? Image.network(
                      team.teamLogoUrl,
                      width: 50,
                      height: 50,
                    )
                        : Container(),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamDetailPage(team: team),
                ),
              );
            },
          );
        },
      );
    }
  }
}

class SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }
}

class TeamDetailPage extends StatelessWidget {
  final EPLTeam team;

  const TeamDetailPage({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        title: Text(team.name, style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: team.teamLogoUrl.isNotEmpty
                    ? Image.network(
                  team.logoUrl,
                  width: 100,
                  height: 100,
                )
                    : Container(),
              ),
              Text('Name: ${team.name}', style: TextStyle(fontSize: 18, color: Colors.white)),
              Text('Stadium: ${team.stadium}', style: TextStyle(fontSize: 18, color: Colors.white)),
              Text('Formed Year: ${team.formedYear}', style: TextStyle(fontSize: 18, color: Colors.white)),
              Text('Sport: ${team.sport}', style: TextStyle(fontSize: 18, color: Colors.white)),
              Center(
                child: team.teamLogoUrl.isNotEmpty
                    ? Image.network(
                  team.jerseyUrl,
                  width: 100,
                  height: 100,
                )
                    : Container(),
              ),
              Text('Description: ${team.description}', style: TextStyle(fontSize: 18, color: Colors.white)),

            ],
          ),
        ),
      ),
    );
  }
}
