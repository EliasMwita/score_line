import 'dart:convert';
import 'package:http/http.dart' as http;

class EPLTeam {
  final String id;
  final String name;
  final String shortName;
  final String alternateNames;
  final String formedYear;
  final String sport;
  final String league;
  final String division;
  final String stadium;
  final String stadiumLocation;
  final String stadiumCapacity;
  final String keywords;
  final String website;
  final String facebook;
  final String twitter;
  final String instagram;
  final String rss;
  final String description;
  final String logoUrl;
  final String jerseyUrl;
  final String teamLogoUrl;
  final String fanart1Url;
  final String fanart2Url;
  final String fanart3Url;
  final String fanart4Url;
  final String bannerUrl;
  final String youtubeUrl;

  EPLTeam({
    required this.id,
    required this.name,
    required this.shortName,
    required this.alternateNames,
    required this.formedYear,
    required this.sport,
    required this.league,
    required this.division,
    required this.stadium,
    required this.stadiumLocation,
    required this.stadiumCapacity,
    required this.keywords,
    required this.website,
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.rss,
    required this.description,
    required this.logoUrl,
    required this.jerseyUrl,
    required this.teamLogoUrl,
    required this.fanart1Url,
    required this.fanart2Url,
    required this.fanart3Url,
    required this.fanart4Url,
    required this.bannerUrl,
    required this.youtubeUrl,
  });

  factory EPLTeam.fromJson(Map<String, dynamic> json) {
    return EPLTeam(
      id: json['idTeam'],
      name: json['strTeam'],
      shortName: json['strTeamShort'] ?? '',
      alternateNames: json['strAlternate'] ?? '',
      formedYear: json['intFormedYear'] ?? '',
      sport: json['strSport'] ?? '',
      league: json['strLeague'] ?? '',
      division: json['strDivision'] ?? '',
      stadium: json['strStadium'] ?? '',
      stadiumLocation: json['strStadiumLocation'] ?? '',
      stadiumCapacity: json['intStadiumCapacity'] ?? '',
      keywords: json['strKeywords'] ?? '',
      website: json['strWebsite'] ?? '',
      facebook: json['strFacebook'] ?? '',
      twitter: json['strTwitter'] ?? '',
      instagram: json['strInstagram'] ?? '',
      rss: json['strRSS'] ?? '',
      description: json['strDescriptionEN'] ?? '',
      logoUrl: json['strTeamBadge'] ?? '',
      jerseyUrl: json['strTeamJersey'] ?? '',
      teamLogoUrl: json['strTeamLogo'] ?? '',
      fanart1Url: json['strTeamFanart1'] ?? '',
      fanart2Url: json['strTeamFanart2'] ?? '',
      fanart3Url: json['strTeamFanart3'] ?? '',
      fanart4Url: json['strTeamFanart4'] ?? '',
      bannerUrl: json['strTeamBanner'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
    );
  }
}

Future<List<EPLTeam>> fetchEPLTeams() async {
  final response = await http.get(Uri.parse('https://www.thesportsdb.com/api/v1/json/3/search_all_teams.php?l=English%20Premier%20League'));

  if (response.statusCode == 200) {
    final List<dynamic> teamsJson = jsonDecode(response.body)['teams'];
    return teamsJson.map((json) => EPLTeam.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load EPL teams');
  }
}
