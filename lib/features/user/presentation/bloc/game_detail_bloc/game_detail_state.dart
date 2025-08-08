import 'package:games_app/features/games/data/models/game_detail_model.dart';

abstract class GameDetailState {}

class GameDetailInitial extends GameDetailState {}

class GameDetailLoading extends GameDetailState {}

class GameDetailLoaded extends GameDetailState {
  final GameDetailModel gameDetail;
  final List<String> gameScreenShots;
  GameDetailLoaded(this.gameDetail, this.gameScreenShots);
}

class GameDetailError extends GameDetailState {
  final String message;
  GameDetailError(this.message);
}
