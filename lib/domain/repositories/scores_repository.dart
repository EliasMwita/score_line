import '../models/team.dart';
import '../models/event.dart';
import '../models/league.dart';
import '../models/player.dart';

abstract class ScoresRepository {
  Future<List<Team>> getTeams();
  Future<List<Event>> getEvents();
  Future<List<League>> getLeagues();
  Future<List<Player>> searchPlayers(String query);
}
