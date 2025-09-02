import 'package:dio/dio.dart';
import 'package:games_app/core/secrets/api_key.dart';
import 'package:games_app/features/games/data/models/game_detail_model.dart';
import 'package:games_app/features/games/data/models/game_model.dart';
import 'package:games_app/features/games/data/models/genre_model.dart';

class GameRemoteDataSource {
  final Dio dio;
  final String apiKey = myApiKey;
  final String baseURl = myBaseURL;

  GameRemoteDataSource({required this.dio});

  Future<List<GameModel>> searchgames({String? query, bool exact =false}) async {
    final params = <String, dynamic> {'key': apiKey};
    if(query != null && query.isNotEmpty){
      params['search'] = query;

      if(exact){
        params['search_exact'] = 'true';
      }
    }
    final response = await dio.get(
      '$baseURl/games',
      queryParameters: params,
    );

    final results = response.data['results'] as List;
    return results.map((json) => GameModel.fromJson(json)).toList();
  }

  Future<List<GameModel>> fetchRecentgames() async {
    final response = await dio.get(
      '$baseURl/games',
      queryParameters: {'page_size': 10, 'genres': 'action', 'key': apiKey},
    );
    final results = response.data['results'] as List;

    return results.map((json) => GameModel.fromJson(json)).toList();
  }

  Future<List<GenreModel>> getGenres() async {
    final response = await dio.get(
      '$baseURl/genres',
      queryParameters: {'key': apiKey},
    );
    final results = response.data['results'] as List;
    return results.map((json) => GenreModel.fromJson(json)).toList();
  }

  Future<List<GameModel>> getGamesByGenre(int genreId) async {
    final response = await dio.get(
      '$baseURl/games',
      queryParameters: {'key': apiKey, "genres": genreId.toString()},
    );
    final results = response.data['results'] as List;
    return results.map((json) => GameModel.fromJson(json)).toList();
  }

  Future<GameDetailModel> showDetailedGame(int gameId) async {
    final response = await dio.get(
      '$baseURl/games/$gameId',
      queryParameters: {'key': apiKey, 'screenshots_count': 5},
    );

    return GameDetailModel.fromJson(response.data);
  }

  Future<List<String>> getScreenShots(int gameId) async {
    final response = await dio.get(
      '$baseURl/games/${gameId.toString()}/screenshots',
      queryParameters: {'key': apiKey, 'page': 1, 'page_size': 10},
    );

    final screenshots = response.data['results'] as List<dynamic>?;

    if (screenshots == null) {
      return [];
    }

    return screenshots.map<String>((json) => json['image'] as String).toList();
  }
}
