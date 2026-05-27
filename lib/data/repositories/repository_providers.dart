import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_providers.dart';
import '../datasources/scores_remote_data_source.dart';
import '../repositories/scores_repository_impl.dart';
import '../../domain/repositories/scores_repository.dart';

final scoresRemoteDataSourceProvider = Provider<ScoresRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ScoresRemoteDataSourceImpl(apiClient);
});

final scoresRepositoryProvider = Provider<ScoresRepository>((ref) {
  final remoteDataSource = ref.watch(scoresRemoteDataSourceProvider);
  return ScoresRepositoryImpl(remoteDataSource);
});
