class GameDetailModel {
  final int id;
  final String? name;
  final String? description;
  final String? backgroundImage;
  final double? rating;
  final List<String> screenshots;

  GameDetailModel({
    required this.id,
    this.name,
    this.description,
    this.backgroundImage,
    this.rating,
    this.screenshots = const [],
  });

  factory GameDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse screenshots se existirem
    final screenshotsJson = json['short_screenshots'] as List<dynamic>?;

    return GameDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description_raw'],
      backgroundImage: json['background_image'],
      rating: (json['rating'] as num?)?.toDouble(),
      screenshots: screenshotsJson != null
          ? screenshotsJson.map((s) => s['image'] as String).toList()
          : [],
    );
  }
}
