import 'dart:convert';
import 'package:http/http.dart' as http;

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

    // Filter the leagues where strSport is equal to "Soccer"
    final soccerLeaguesJson = leaguesJson.where((json) => json['strSport'] == 'Soccer').toList();


    return soccerLeaguesJson.map((json) => League.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load leagues');
  }
}
