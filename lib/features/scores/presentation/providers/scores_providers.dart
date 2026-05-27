import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/event.dart';
import '../../../../data/repositories/repository_providers.dart';

class ScoresState {
  final bool isLoading;
  final List<Event> matches;
  final String? error;

  ScoresState({
    this.isLoading = false,
    this.matches = const [],
    this.error,
  });

  ScoresState copyWith({
    bool? isLoading,
    List<Event>? matches,
    String? error,
  }) {
    return ScoresState(
      isLoading: isLoading ?? this.isLoading,
      matches: matches ?? this.matches,
      error: error ?? this.error,
    );
  }
}

class ScoresNotifier extends StateNotifier<ScoresState> {
  final Ref _ref;

  ScoresNotifier(this._ref) : super(ScoresState()) {
    getEvents();
  }

  Future<void> getEvents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = _ref.read(scoresRepositoryProvider);
      final events = await repository.getEvents();
      state = state.copyWith(isLoading: false, matches: events);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final scoresNotifierProvider = StateNotifierProvider<ScoresNotifier, ScoresState>((ref) {
  return ScoresNotifier(ref);
});

final eventsFutureProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(scoresRepositoryProvider);
  return await repository.getEvents();
});
