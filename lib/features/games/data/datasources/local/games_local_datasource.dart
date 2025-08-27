import 'package:games_app/features/games/data/models/game_model.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';

class GamesLocalDataSource {
  final DatabaseHelper databaseHelper;

  GamesLocalDataSource(this.databaseHelper);

  Future<void> cacheGames(List<GameModel> games) async {
    final db = await databaseHelper.database;
    for (var game in games) {
      await db.insert(
        'games',
        game.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<GameModel>> getCachedGames() async {
    final db = await databaseHelper.database;
    final maps = await db.query('games');
    return maps.map((map) => GameModel.fromDb(map)).toList();
  }

  Future<void> addFavorite(GameModel game) async {
    final db = await databaseHelper.database;
    await db.insert(
      'favorites',
      game.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<GameModel>> getFavorites() async {
    final db = await databaseHelper.database;
    final maps = await db.query('favorites');
    return maps.map((map) => GameModel.fromDb(map)).toList();
  }
}
