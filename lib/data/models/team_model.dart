import '../../domain/models/team.dart';

class TeamModel extends Team {
  TeamModel({
    required super.idTeam,
    required super.strTeam,
    required super.strAlternate,
    required super.strSport,
    required super.strLeague,
    required super.strStadium,
    required super.strStadiumLocation,
    required super.strWebsite,
    required super.strFacebook,
    required super.strTwitter,
    required super.strInstagram,
    required super.strDescriptionEN,
    required super.strTeamBadge,
    required super.strTeamJersey,
    required super.strStadiumThumb,
    required super.strTeamFanart1,
    required super.strTeamFanart2,
    required super.strTeamFanart3,
    required super.strTeamFanart4,
    required super.strTeamBanner,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      idTeam: json['idTeam'] ?? '',
      strTeam: json['strTeam'] ?? '',
      strAlternate: json['strAlternate'] ?? '',
      strSport: json['strSport'] ?? '',
      strLeague: json['strLeague'] ?? '',
      strStadium: json['strStadium'] ?? '',
      strStadiumLocation: json['strStadiumLocation'] ?? '',
      strWebsite: json['strWebsite'] ?? '',
      strFacebook: json['strFacebook'] ?? '',
      strTwitter: json['strTwitter'] ?? '',
      strInstagram: json['strInstagram'] ?? '',
      strDescriptionEN: json['strDescriptionEN'] ?? '',
      strTeamBadge: json['strTeamBadge'] ?? '',
      strTeamJersey: json['strTeamJersey'] ?? '',
      strStadiumThumb: json['strStadiumThumb'] ?? '',
      strTeamFanart1: json['strTeamFanart1'] ?? '',
      strTeamFanart2: json['strTeamFanart2'] ?? '',
      strTeamFanart3: json['strTeamFanart3'] ?? '',
      strTeamFanart4: json['strTeamFanart4'] ?? '',
      strTeamBanner: json['strTeamBanner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTeam': idTeam,
      'strTeam': strTeam,
      'strAlternate': strAlternate,
      'strSport': strSport,
      'strLeague': strLeague,
      'strStadium': strStadium,
      'strStadiumLocation': strStadiumLocation,
      'strWebsite': strWebsite,
      'strFacebook': strFacebook,
      'strTwitter': strTwitter,
      'strInstagram': strInstagram,
      'strDescriptionEN': strDescriptionEN,
      'strTeamBadge': strTeamBadge,
      'strTeamJersey': strTeamJersey,
      'strStadiumThumb': strStadiumThumb,
      'strTeamFanart1': strTeamFanart1,
      'strTeamFanart2': strTeamFanart2,
      'strTeamFanart3': strTeamFanart3,
      'strTeamFanart4': strTeamFanart4,
      'strTeamBanner': strTeamBanner,
    };
  }
}
