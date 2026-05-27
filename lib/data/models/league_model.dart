import '../../domain/models/league.dart';

class LeagueModel extends League {
  const LeagueModel({
    required super.idLeague,
    required super.leagueName,
    required super.sport,
    required super.leagueAlternate,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
      idLeague: json['idLeague'] as String,
      leagueName: json['strLeague'] as String,
      sport: json['strSport'] as String,
      leagueAlternate: json['strLeagueAlternate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idLeague': idLeague,
      'strLeague': leagueName,
      'strSport': sport,
      'strLeagueAlternate': leagueAlternate,
    };
  }
}
