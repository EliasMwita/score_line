import 'dart:convert';
import 'package:http/http.dart' as http;

class Team {
  final String idTeam;
  final String strTeam;
  final String strAlternate;
  final String strSport;
  final String strLeague;
  final String strStadium;
  final String strStadiumLocation;
  final String strWebsite;
  final String strFacebook;
  final String strTwitter;
  final String strInstagram;
  final String strDescriptionEN;
  final String strTeamBadge;
  final String strTeamJersey;
  final String strStadiumThumb;
  final String strTeamFanart1;
  final String strTeamFanart2;
  final String strTeamFanart3;
  final String strTeamFanart4;
  final String strTeamBanner;

  Team({
    required this.idTeam,
    required this.strTeam,
    required this.strAlternate,
    required this.strSport,
    required this.strLeague,
    required this.strStadium,
    required this.strStadiumLocation,
    required this.strWebsite,
    required this.strFacebook,
    required this.strTwitter,
    required this.strInstagram,
    required this.strDescriptionEN,
    required this.strTeamBadge,
    required this.strTeamJersey,
    required this.strStadiumThumb,
    required this.strTeamFanart1,
    required this.strTeamFanart2,
    required this.strTeamFanart3,
    required this.strTeamFanart4,
    required this.strTeamBanner,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      idTeam: json['idTeam'],
      strTeam: json['strTeam'],
      strAlternate: json['strAlternate'] ?? '',
      strSport: json['strSport'],
      strLeague: json['strLeague'],
      strStadium: json['strStadium'],
      strStadiumLocation: json['strStadiumLocation'],
      strWebsite: json['strWebsite'],
      strFacebook: json['strFacebook'],
      strTwitter: json['strTwitter'],
      strInstagram: json['strInstagram'],
      strDescriptionEN: json['strDescriptionEN'] ?? '',
      strTeamBadge: json['strTeamBadge'],
      strTeamJersey: json['strTeamJersey'],
      strStadiumThumb: json['strStadiumThumb'],
      strTeamFanart1: json['strTeamFanart1'],
      strTeamFanart2: json['strTeamFanart2'],
      strTeamFanart3: json['strTeamFanart3'],
      strTeamFanart4: json['strTeamFanart4'],
      strTeamBanner: json['strTeamBanner'],
    );
  }
}

Future<List<Team>> fetchTeams() async {
  final response = await http.get(Uri.parse('https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t'));

  if (response.statusCode == 200) {
    final List<dynamic> teamsJson = jsonDecode(response.body)['teams'];
    return teamsJson.map((json) => Team.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load teams');
  }
}
