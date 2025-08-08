import 'package:games_app/features/games/data/models/game_model.dart';
import 'package:games_app/features/games/data/models/genre_model.dart';

abstract class GameState {}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GenreLoading extends GameState {}

class GenreLoaded extends GameState {
  final List<GenreModel> genres;
  GenreLoaded(this.genres);
}

class GameLoaded extends GameState {
  final List<GameModel> games;
  final List<GenreModel> genres;
  GameLoaded({required this.games, required this.genres});
}

class GameError extends GameState {
  final String message;
  GameError(this.message);
}
