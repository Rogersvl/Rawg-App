import 'package:games_app/features/games/domain/entities/game.dart';

class GameModel extends Game {
  GameModel({
    required super.id,
    required super.name,
    super.backgroundImage,
    super.released,
    super.rating,
  });
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      backgroundImage: json['background_image'],
      released: json['released'],
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
  factory GameModel.fromDb(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'],
      name: map['name'],
      backgroundImage: map['backgroundImage'],
      released: map['released'],
      rating: (map['rating'] as num?)?.toDouble(),
    );
  }
  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'name': name,
      'backgroundImage': backgroundImage,
      'released': released,
      'rating': rating,
    };
  }

  Game toEntity() => Game(
    id: id,
    name: name,
    backgroundImage: backgroundImage,
    released: released,
    rating: rating,
  );
  factory GameModel.fromEntity(Game game) {
    return GameModel(
      id: game.id,
      name: game.name,
      backgroundImage: game.backgroundImage,
      released: game.released,
      rating: game.rating,
    );
  }
}
