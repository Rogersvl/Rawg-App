abstract class GameEvent {}

class SearchGames extends GameEvent {
  final String query;

  SearchGames(this.query);
}

class FetchRecentGames extends GameEvent {}

class GetGenres extends GameEvent {}

class FilterGamesByGenre extends GameEvent {
  final int genreId;
  FilterGamesByGenre(this.genreId);
}
