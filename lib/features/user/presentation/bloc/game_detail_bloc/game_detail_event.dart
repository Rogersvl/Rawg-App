abstract class GameDetailEvent {}

class FetchGameDetails extends GameDetailEvent {
  final int gameID;

  FetchGameDetails({required this.gameID});
}
