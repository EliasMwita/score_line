class Player {
  final String idPlayer;
  final String strPlayer;
  final String strTeam;
  final String? strNationality;
  final String? strDescriptionEN;
  final String? strThumb;
  final String? position;
  final String? number;

  Player({
    required this.idPlayer,
    required this.strPlayer,
    required this.strTeam,
    this.strNationality,
    this.strDescriptionEN,
    this.strThumb,
    this.position,
    this.number,
  });
}
