class GenreModel {
  final int id;
  final String name;
  final String slug;
  final String imageBackground;

  GenreModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageBackground,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      imageBackground: json['image_background'] ?? '',
    );
  }
}
