import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoreline/domain/models/event.dart';

// Navigation provider for bottom nav
class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

// Live scores stream provider fetching from real API
final liveScoresStreamProvider = StreamProvider<List<Event>>((ref) async* {
  // Use a timer-based stream for polling the API
  while (true) {
    try {
      // In a real app, these IDs would come from user selection or config
      // 4328 is EPL, 2023-2024 season
      final response = await http.get(Uri.parse(
          'https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4328&s=2023-2024'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['events'] != null) {
          final List<dynamic> eventsJson = data['events'];
          
          // Map API data to our Event model
          final events = eventsJson.map((json) {
            return Event(
              idEvent: json['idEvent'] ?? '',
              strEvent: json['strEvent'] ?? '',
              strHomeTeam: json['strHomeTeam'] ?? '',
              strAwayTeam: json['strAwayTeam'] ?? '',
              intHomeScore: json['intHomeScore'] ?? '0',
              intAwayScore: json['intAwayScore'] ?? '0',
              strStatus: json['strStatus'],
              strLeague: json['strLeague'],
              strProgress: json['strProgress'],
              strTime: json['strTime'],
              strHomeTeamBadge: json['strHomeTeamBadge'] ?? '',
              strAwayTeamBadge: json['strAwayTeamBadge'] ?? '',
              strVenue: json['strVenue'],
              strDate: json['dateEvent'],
              strSeason: json['strSeason'],
              isWorldCup: (json['strLeague'] ?? '').contains('World Cup'),
            );
          }).toList();
          
          yield events;
        } else {
          // If no events found, yield empty list or previous state
          yield [];
        }
      }
    } catch (e) {
      // Log error but don't break the stream
      print('Error fetching scores: $e');
    }

    // Poll every 30 seconds to respect API limits
    await Future.delayed(const Duration(seconds: 30));
  }
});
