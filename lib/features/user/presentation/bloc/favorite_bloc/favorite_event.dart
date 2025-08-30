import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable{
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}


class LoadFavorites extends FavoriteEvent {
  final int userID;
  const LoadFavorites(this.userID);
}


class AddFavorite extends FavoriteEvent {
  final int userID;
  final int gameID;
  final String name;
  final String backgroundImage;

  const AddFavorite({required this.userID,  required this.gameID, required this.name, required this.backgroundImage});
}


class RemoveFavorite extends FavoriteEvent {
  final int favoriteID;
  final int userID;
  const RemoveFavorite({required this.favoriteID,  required this.userID});
}



class UpdateFavoriteRating extends FavoriteEvent{
  final int favoriteID;
  final double rating;
  final int userID;

  const UpdateFavoriteRating({required this.favoriteID, required this.rating, required this.userID});
}