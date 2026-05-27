import 'dart:convert';
import '../../core/network/api_client.dart';
import '../models/team_model.dart';
import '../models/event_model.dart';
import '../models/league_model.dart';
import '../models/player_model.dart';

abstract class ScoresRemoteDataSource {
  Future<List<TeamModel>> getTeams();
  Future<List<EventModel>> getEvents();
  Future<List<LeagueModel>> getLeagues();
  Future<List<PlayerModel>> searchPlayers(String query);
}

class ScoresRemoteDataSourceImpl implements ScoresRemoteDataSource {
  final ApiClient _apiClient;

  ScoresRemoteDataSourceImpl(this._apiClient);

  Map<String, dynamic> _ensureMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is String) {
      return jsonDecode(data);
    } else {
      return {};
    }
  }

  @override
  Future<List<TeamModel>> getTeams() async {
    final response = await _apiClient.get('/searchteams.php?t=Soccer');
    final data = _ensureMap(response.data);
    final List<dynamic> teams = data['teams'] ?? [];
    return teams.map((json) => TeamModel.fromJson(json)).toList();
  }

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      // Fetch multiple sources to have a diverse set of matches
      final results = await Future.wait([
        // Premier League
        _apiClient.get('/eventsseason.php?id=4328&s=2023-2024'),
        // World Cup (4429) - 2026 season
        _apiClient.get('/eventsseason.php?id=4429&s=2026'), 
        // Live events if any (paid tier usually, but some might show up)
        _apiClient.get('/latestsoccer.php'),
      ]);

      final List<EventModel> allEvents = [];
      
      for (final response in results) {
        if (response.data != null) {
          final data = _ensureMap(response.data);
          final List<dynamic> eventsJson = data['events'] ?? data['results'] ?? [];
          allEvents.addAll(eventsJson.map((json) => EventModel.fromJson(json)));
        }
      }

      // If we got nothing, try to at least get something from a known active endpoint
      if (allEvents.isEmpty) {
        final fallback = await _apiClient.get('/eventsnextleague.php?id=4328');
        final data = _ensureMap(fallback.data);
        final List<dynamic> eventsJson = data['events'] ?? [];
        allEvents.addAll(eventsJson.map((json) => EventModel.fromJson(json)));
      }

      return allEvents;
    } catch (e) {
      // Fallback or rethrow
      return [];
    }
  }

  @override
  Future<List<LeagueModel>> getLeagues() async {
    final response = await _apiClient.get('/all_leagues.php');
    final data = _ensureMap(response.data);
    final List<dynamic> leagues = data['leagues'] ?? [];
    return leagues
        .where((json) => json['strSport'] == 'Soccer')
        .map((json) => LeagueModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<PlayerModel>> searchPlayers(String query) async {
    final response = await _apiClient.get('/searchplayers.php?p=$query');
    final data = _ensureMap(response.data);
    final List<dynamic> players = data['player'] ?? [];
    return players.map((json) => PlayerModel.fromJson(json)).toList();
  }
}
