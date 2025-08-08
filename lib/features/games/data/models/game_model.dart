class GameModel {
  final int id;
  final String name;
  final String? backgroundImage;
  final String? released;
  final double? rating;

  GameModel({
    required this.id,
    required this.name,
    this.backgroundImage,
    this.released,
    this.rating,
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
}
