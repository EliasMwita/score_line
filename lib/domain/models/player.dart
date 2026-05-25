import 'dart:convert';
import 'package:http/http.dart' as http;

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
    this.idPlayer = '',
    String? name,
    String? strPlayer,
    this.strTeam = '',
    this.strNationality,
    this.strDescriptionEN,
    this.strThumb,
    this.position,
    this.number,
  }) : strPlayer = strPlayer ?? name ?? 'Unknown';

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
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

  static Future<List<Player>> fetchPlayerData(String playerName) async {
    final response = await http.get(Uri.parse('https://www.thesportsdb.com/api/v1/json/3/searchplayers.php?p=$playerName'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['player'] == null) return [];
      final List<dynamic> playersJson = data['player'];
      return playersJson.map((json) => Player.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }
}
