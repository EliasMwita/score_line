import 'dart:convert';
import 'package:http/http.dart' as http;

class Event {
  final String idEvent;
  final String? idSoccerXML;
  final String idAPIfootball;
  final String strEvent;
  final String strEventAlternate;
  final String strFilename;
  final String strSport;
  final String idLeague;
  final String strLeague;
  final String strSeason;
  final String? strDescriptionEN;
  final String strHomeTeam;
  final String strAwayTeam;
  final String intHomeScore;
  final String intRound;
  final String intAwayScore;
  final String? intSpectators;
  final String? strOfficial;
  final String strTimestamp;
  final String dateEvent;
  final String dateEventLocal;
  final String strTime;
  final String strTimeLocal;
  final String? strTVStation;
  final String idHomeTeam;
  final String strHomeTeamBadge;
  final String idAwayTeam;
  final String strAwayTeamBadge;
  final String? intScore;
  final String? intScoreVotes;
  final String? strResult;
  final String? idVenue;
  final String strVenue;
  final String strCountry;
  final String? strCity;
  final String strPoster;
  final String strSquare;
  final String? strFanart;
  final String strThumb;
  final String strBanner;
  final String? strMap;
  final String? strTweet1;
  final String? strTweet2;
  final String? strTweet3;
  final String? strVideo;
  final String strStatus;
  final String strPostponed;
  final String strLocked;

  Event({
    required this.idEvent,
    this.idSoccerXML,
    required this.idAPIfootball,
    required this.strEvent,
    required this.strEventAlternate,
    required this.strFilename,
    required this.strSport,
    required this.idLeague,
    required this.strLeague,
    required this.strSeason,
    this.strDescriptionEN,
    required this.strHomeTeam,
    required this.strAwayTeam,
    required this.intHomeScore,
    required this.intRound,
    required this.intAwayScore,
    this.intSpectators,
    this.strOfficial,
    required this.strTimestamp,
    required this.dateEvent,
    required this.dateEventLocal,
    required this.strTime,
    required this.strTimeLocal,
    this.strTVStation,
    required this.idHomeTeam,
    required this.strHomeTeamBadge,
    required this.idAwayTeam,
    required this.strAwayTeamBadge,
    this.intScore,
    this.intScoreVotes,
    this.strResult,
    this.idVenue,
    required this.strVenue,
    required this.strCountry,
    this.strCity,
    required this.strPoster,
    required this.strSquare,
    this.strFanart,
    required this.strThumb,
    required this.strBanner,
    this.strMap,
    this.strTweet1,
    this.strTweet2,
    this.strTweet3,
    this.strVideo,
    required this.strStatus,
    required this.strPostponed,
    required this.strLocked,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      idEvent: json['idEvent'],
      idSoccerXML: json['idSoccerXML'],
      idAPIfootball: json['idAPIfootball'],
      strEvent: json['strEvent'],
      strEventAlternate: json['strEventAlternate'],
      strFilename: json['strFilename'],
      strSport: json['strSport'],
      idLeague: json['idLeague'],
      strLeague: json['strLeague'],
      strSeason: json['strSeason'],
      strDescriptionEN: json['strDescriptionEN'],
      strHomeTeam: json['strHomeTeam'],
      strAwayTeam: json['strAwayTeam'],
      intHomeScore: json['intHomeScore'],
      intRound: json['intRound'],
      intAwayScore: json['intAwayScore'],
      intSpectators: json['intSpectators'],
      strOfficial: json['strOfficial'],
      strTimestamp: json['strTimestamp'],
      dateEvent: json['dateEvent'],
      dateEventLocal: json['dateEventLocal'],
      strTime: json['strTime'],
      strTimeLocal: json['strTimeLocal'],
      strTVStation: json['strTVStation'],
      idHomeTeam: json['idHomeTeam'],
      strHomeTeamBadge: json['strHomeTeamBadge'],
      idAwayTeam: json['idAwayTeam'],
      strAwayTeamBadge: json['strAwayTeamBadge'],
      intScore: json['intScore'],
      intScoreVotes: json['intScoreVotes'],
      strResult: json['strResult'],
      idVenue: json['idVenue'],
      strVenue: json['strVenue'],
      strCountry: json['strCountry'],
      strCity: json['strCity'],
      strPoster: json['strPoster'],
      strSquare: json['strSquare'],
      strFanart: json['strFanart'],
      strThumb: json['strThumb'],
      strBanner: json['strBanner'],
      strMap: json['strMap'],
      strTweet1: json['strTweet1'],
      strTweet2: json['strTweet2'],
      strTweet3: json['strTweet3'],
      strVideo: json['strVideo'],
      strStatus: json['strStatus'],
      strPostponed: json['strPostponed'],
      strLocked: json['strLocked'],
    );
  }

  static List<Event> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Event.fromJson(json)).toList();
  }

  static Future<List<Event>> fetchEvents(String id, String season) async {
    final response = await http.get(Uri.parse('https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=$id&s=$season'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> eventsJson = data['events'];
      return Event.fromJsonList(eventsJson);
    } else {
      throw Exception('Failed to load events');
    }
  }
}
