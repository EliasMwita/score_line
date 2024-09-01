import 'dart:convert';
import 'package:http/http.dart' as http;

class Player {
  final String idPlayer;
  final String strPlayer;
  final String strTeam;
  final String strNationality;
  final String strDescriptionEN;
  final String strThumb;
  final String strFanart1;
  final String strFanart2;
  final String strFanart3;
  final String strFanart4;

  Player({
    required this.idPlayer,
    required this.strPlayer,
    required this.strTeam,
    required this.strNationality,
    required this.strDescriptionEN,
    required this.strThumb,
    required this.strFanart1,
    required this.strFanart2,
    required this.strFanart3,
    required this.strFanart4,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      idPlayer: json['idPlayer'] ?? '',
      strPlayer: json['strPlayer'] ?? 'Unknown Player',
      strTeam: json['strTeam'] ?? 'Unknown Team',
      strNationality: json['strNationality'] ?? 'Unknown Nationality',
      strDescriptionEN: json['strDescriptionEN'] ?? 'No Description',
      strThumb: json['strThumb'] ?? '',
      strFanart1: json['strFanart1'] ?? '',
      strFanart2: json['strFanart2'] ?? '',
      strFanart3: json['strFanart3'] ?? '',
      strFanart4: json['strFanart4'] ?? '',
    );
  }

  static Future<List<Player>> fetchPlayerData(String playerName) async {
    final response = await http.get(Uri.parse('https://www.thesportsdb.com/api/v1/json/3/searchplayers.php?p=$playerName'));

    if (response.statusCode == 200) {
      final List<dynamic> playersJson = jsonDecode(response.body)['player'];
      return playersJson.map((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }
}
