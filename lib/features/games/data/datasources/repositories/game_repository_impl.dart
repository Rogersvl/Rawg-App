import 'package:games_app/features/games/data/datasources/local/games_local_datasource.dart';
import 'package:games_app/features/games/data/datasources/remote/game_remote_data_source.dart';
import 'package:games_app/features/games/data/models/game_model.dart';
import 'package:games_app/features/games/domain/entities/game.dart';


class GameRepositoryImpl {
  final GameRemoteDataSource remoteDataSource;
  final GamesLocalDataSource localDataSource;

  GameRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Pega jogos recentes, com opção de forçar refresh
  Future<List<Game>> getGames({bool forceRefresh = false}) async {
    if (forceRefresh) {
      final remoteGames = await remoteDataSource.fetchRecentgames();
      await localDataSource.cacheGames(remoteGames);
      return remoteGames.map((g) => g.toEntity()).toList();
    }

    final localGames = await localDataSource.getCachedGames();
    if (localGames.isNotEmpty) {
      return localGames.map((g) => g.toEntity()).toList();
    }

    final remoteGames = await remoteDataSource.fetchRecentgames();
    await localDataSource.cacheGames(remoteGames);
    return remoteGames.map((g) => g.toEntity()).toList();
  }

  // Pesquisa jogos
  Future<List<Game>> searchGames(String query, {bool exact = false}) async {
    final remoteGames = await remoteDataSource.searchgames(
      query: query,
      exact: exact,
    );
    return remoteGames.map((g) => g.toEntity()).toList();
  }

  // Favoritos
  Future<void> addFavorite(Game game) async {
    await localDataSource.addFavorite(GameModel.fromEntity(game));
  }

  Future<void> removeFavorite(int id) async {
    await localDataSource.removeFavorite(id);
  }

  Future<List<Game>> getFavorites() async {
    final localFavorites = await localDataSource.getFavorites();
    return localFavorites.map((g) => g.toEntity()).toList();
  }
}
