import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'EplTeams.dart';

class League {
  final String idLeague;
  final String leagueName;
  final String sport;
  final String leagueAlternate;

  const League({
    required this.idLeague,
    required this.leagueName,
    required this.sport,
    required this.leagueAlternate,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      idLeague: json['idLeague'] as String,
      leagueName: json['strLeague'] as String,
      sport: json['strSport'] as String,
      leagueAlternate: json['strLeagueAlternate'] as String? ?? '',
    );
  }
}

Future<List<League>> fetchLeagues() async {
  final response = await http.get(Uri.parse('https://www.thesportsdb.com/api/v1/json/3/all_leagues.php'));

  if (response.statusCode == 200) {
    final List<dynamic> leaguesJson = jsonDecode(response.body)['leagues'] as List<dynamic>;
    return leaguesJson.where((json) => json['strSport'] == 'Soccer').map((json) => League.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load leagues');
  }
}

class NavBar extends StatelessWidget {
  final Future<List<League>> futureLeagues = fetchLeagues();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                const Text(
                  'Leagues',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<League>>(
                    future: futureLeagues,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}', style: const TextStyle(color: Colors.white)),
                        );
                      } else if (snapshot.hasData) {
                        final leagues = snapshot.data!;
                        return ListView.builder(
                          itemCount: leagues.length,
                          itemBuilder: (context, index) {
                            final league = leagues[index];
                            return ListTile(
                              title: Text(
                                league.leagueName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                league.sport,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              onTap: () {
                                if (league.leagueName == 'English Premier League') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EPLTeams(title: 'English Premier League'),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LeagueDetailPage(league: league),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No data found', style: TextStyle(color: Colors.white)),
                        );
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Close', style: TextStyle(color: Colors.white)),
                        Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class LeagueDetailPage extends StatelessWidget {
  final League league;

  const LeagueDetailPage({Key? key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(league.leagueName, style: const TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'League: ${league.leagueName}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                'Sport: ${league.sport}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                'Alternate Name: ${league.leagueAlternate}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
