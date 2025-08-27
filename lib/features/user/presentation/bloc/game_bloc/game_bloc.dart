// import 'package:games_app/features/games/data/datasources/game_remote_data_source.dart';

import 'package:games_app/features/games/data/datasources/remote/game_remote_data_source.dart';
import 'package:games_app/features/games/data/models/game_model.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_event.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRemoteDataSource repository;

  GameBloc(this.repository) : super(GameInitial()) {
    on<FetchRecentGames>(_onFetchRecentGames);
    on<GetGenres>(_onGetGenres);
    on<FilterGamesByGenre>(_onFilterGamesByGenre);
    on<SearchGames>(_onSearchGames);
    on<SortGamesByRatingEvent>(_onSortGamesByRating);
  }

  Future<void> _onSearchGames(
    SearchGames event,
    Emitter<GameState> emit,
  ) async {
    try {
      final game = await repository.searchgames(query: event.query, exact: event.searchExact);
      final genres = await repository.getGenres();

      emit(GameLoaded(games: game, genres: genres));
    } catch (e) {
      emit(GameError('Jogo não encontrado.'));
    }
  }

  Future<void> _onFetchRecentGames(
    FetchRecentGames event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoading());
    try {
      final games = await repository.fetchRecentgames();
      final genres = await repository.getGenres();
      print("Jogo encontrado: ${games.length}");
      emit(GameLoaded(games: games, genres: genres));
    } catch (e) {
      emit(GameError('Erro ao buscar jogos recentes'));
    }
  }

  Future<void> _onGetGenres(GetGenres event, Emitter<GameState> emit) async {
    emit(GenreLoading());

    try {
      final genres = await repository.getGenres();

      final currentState = state;

      if (currentState is GameLoaded) {
        emit(GameLoaded(games: currentState.games, genres: genres));
      }
    } catch (e) {
      emit(GameError('Erro ao carregar generos.'));
    }
  }

  Future<void> _onFilterGamesByGenre(
    FilterGamesByGenre event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoading());
    try {
      final games = await repository.getGamesByGenre(event.genreId);
      final genres = await repository.getGenres();
      emit(GameLoaded(games: games, genres: genres));
    } catch (e) {
      emit(GameError('Erro ao filtar jogos por gênero'));
    }
  }

  Future<void> _onSortGamesByRating(
    SortGamesByRatingEvent event,  Emitter<GameState> emit
  )async{
    final currentState = state;

    if(currentState is GameLoaded){
      final sortedGames = List<GameModel>.from(currentState.games);

      sortedGames.sort((a, b) {
        final ratingA = a.rating ?? 0;
        final ratingB = b.rating ?? 0;

        return event.descending ? ratingB.compareTo(ratingA) : ratingA.compareTo(ratingB);
      });

      emit(GameLoaded(games: sortedGames, genres: currentState.genres));
    }
  }

}
