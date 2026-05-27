import '../../domain/models/event.dart';

class EventModel extends Event {
  EventModel({
    required super.idEvent,
    required super.strEvent,
    required super.strHomeTeam,
    required super.strAwayTeam,
    required super.intHomeScore,
    required super.intAwayScore,
    super.strStatus,
    super.strLeague,
    super.strProgress,
    super.strTime,
    required super.strHomeTeamBadge,
    required super.strAwayTeamBadge,
    super.strVenue,
    super.strDate,
    super.strSeason,
    super.strCountry,
    super.isWorldCup,
    super.events,
    super.homeLineup,
    super.awayLineup,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final strLeague = json['strLeague'] as String? ?? '';
    final strEvent = json['strEvent'] as String? ?? '';
    final isWorldCup = strLeague.toLowerCase().contains('world cup') || 
                       strEvent.toLowerCase().contains('world cup') ||
                       json['isWorldCup'] == 'true' || 
                       json['isWorldCup'] == true;

    return EventModel(
      idEvent: json['idEvent'] ?? '',
      strEvent: strEvent,
      strHomeTeam: json['strHomeTeam'] ?? '',
      strAwayTeam: json['strAwayTeam'] ?? '',
      intHomeScore: json['intHomeScore'] ?? '0',
      intAwayScore: json['intAwayScore'] ?? '0',
      strStatus: json['strStatus'],
      strLeague: strLeague,
      strProgress: json['strProgress'],
      strTime: json['strTime'],
      strHomeTeamBadge: json['strHomeTeamBadge'] ?? '',
      strAwayTeamBadge: json['strAwayTeamBadge'] ?? '',
      strVenue: json['strVenue'],
      strDate: json['strDate'],
      strSeason: json['strSeason'],
      strCountry: json['strCountry'],
      isWorldCup: isWorldCup,
      // Mapping sub-objects would require more logic if they are in JSON
      // For now keeping it simple as per existing Event class
    );
  }
}
