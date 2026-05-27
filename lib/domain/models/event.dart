import 'package:scoreline/domain/models/player.dart';

class Event {
  final String idEvent;
  final String strEvent;
  final String strHomeTeam;
  final String strAwayTeam;
  final String intHomeScore;
  final String intAwayScore;
  final String? strStatus;
  final String? strLeague;
  final String? strProgress;
  final String? strTime;
  final String strHomeTeamBadge;
  final String strAwayTeamBadge;
  final String? strVenue;
  final String? strDate;
  final String? strSeason;
  final String? strCountry;
  final bool isWorldCup;
  final List<MatchEvent> events;
  final List<Player> homeLineup;
  final List<Player> awayLineup;

  Event({
    required this.idEvent,
    required this.strEvent,
    required this.strHomeTeam,
    required this.strAwayTeam,
    required this.intHomeScore,
    required this.intAwayScore,
    this.strStatus,
    this.strLeague,
    this.strProgress,
    this.strTime,
    required this.strHomeTeamBadge,
    required this.strAwayTeamBadge,
    this.strVenue,
    this.strDate,
    this.strSeason,
    this.strCountry,
    this.isWorldCup = false,
    this.events = const [],
    this.homeLineup = const [],
    this.awayLineup = const [],
  });
}

class MatchEvent {
  final String type;
  final String player;
  final String team;
  final String time;
  final String? cardType;
  final String? assist;

  MatchEvent({
    required this.type,
    required this.player,
    required this.team,
    required this.time,
    this.cardType,
    this.assist,
  });
}


