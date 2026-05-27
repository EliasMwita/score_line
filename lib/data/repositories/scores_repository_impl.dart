import '../../domain/repositories/scores_repository.dart';
import '../../domain/models/team.dart';
import '../../domain/models/event.dart';
import '../../domain/models/league.dart';
import '../datasources/scores_remote_data_source.dart';

import '../../domain/models/player.dart';

class ScoresRepositoryImpl implements ScoresRepository {
  final ScoresRemoteDataSource _remoteDataSource;

  ScoresRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Team>> getTeams() async {
    return await _remoteDataSource.getTeams();
  }

  @override
  Future<List<Event>> getEvents() async {
    return await _remoteDataSource.getEvents();
  }

  @override
  Future<List<League>> getLeagues() async {
    return await _remoteDataSource.getLeagues();
  }

  @override
  Future<List<Player>> searchPlayers(String query) async {
    return await _remoteDataSource.searchPlayers(query);
  }
}
