import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/player.dart';
import '../../../../data/repositories/repository_providers.dart';

final searchPlayersProvider = FutureProvider.family<List<Player>, String>((ref, query) async {
  final repository = ref.watch(scoresRepositoryProvider);
  return await repository.searchPlayers(query);
});
