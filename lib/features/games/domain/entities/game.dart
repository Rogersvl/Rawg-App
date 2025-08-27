class Game {
  final int id;
  final String name;
  final String? backgroundImage;
  final String? released;
  final double? rating;

  Game({
    required this.id,
    required this.name,
    this.backgroundImage,
    this.released,
    this.rating,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Game &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Game{id: $id, name: $name, released: $released, rating: $rating}';
  }
}
