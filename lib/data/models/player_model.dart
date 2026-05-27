import '../../domain/models/player.dart';

class PlayerModel extends Player {
  PlayerModel({
    required super.idPlayer,
    required super.strPlayer,
    required super.strTeam,
    super.strNationality,
    super.strDescriptionEN,
    super.strThumb,
    super.position,
    super.number,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      idPlayer: json['idPlayer'] ?? '',
      strPlayer: json['strPlayer'] ?? 'Unknown Player',
      strTeam: json['strTeam'] ?? 'Unknown Team',
      strNationality: json['strNationality'],
      strDescriptionEN: json['strDescriptionEN'],
      strThumb: json['strThumb'],
      position: json['strPosition'],
      number: json['strNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPlayer': idPlayer,
      'strPlayer': strPlayer,
      'strTeam': strTeam,
      'strNationality': strNationality,
      'strDescriptionEN': strDescriptionEN,
      'strThumb': strThumb,
      'strPosition': position,
      'strNumber': number,
    };
  }
}
