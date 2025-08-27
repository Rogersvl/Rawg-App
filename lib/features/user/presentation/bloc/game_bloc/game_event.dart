abstract class GameEvent {}

class SearchGames extends GameEvent {
  final String query;
  final bool searchExact;

  SearchGames(this.query, {this.searchExact = false});
}

class FetchRecentGames extends GameEvent {}

class GetGenres extends GameEvent {}

class FilterGamesByGenre extends GameEvent {
  final int genreId;
  FilterGamesByGenre(this.genreId);
}

class SortGamesByRatingEvent extends GameEvent {
  final bool descending;

  SortGamesByRatingEvent({this.descending = true});
}
