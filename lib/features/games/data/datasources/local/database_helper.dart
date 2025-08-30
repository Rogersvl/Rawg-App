import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  static const _dbName = 'games.db';
  static const _dbVersion = 2; 

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        profile_image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        game_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        background_image TEXT,
        rating REAL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Caso você adicione novas tabelas ou colunas
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          profile_image_path TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          game_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          background_image TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }



  Future<int> addUser(String name, String email, String password, String? imagePath) async {
    final db = await instance.database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
      'profile_image_path': imagePath
    });
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> addFavorite(int userID, int gameID, String name, String backgroundImage, {double? rating}) async {
    final db = await instance.database;
    return await db.insert('favorites', {
      'user_id': userID,
      'game_id': gameID,
      'name': name,
      'background_image': backgroundImage,
      'rating': rating
    });
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userID) async {
    final db = await instance.database;
    return await db.query('favorites', where: 'user_id = ?', whereArgs: [userID]);
  }

  Future<int> removeFavorite(int favoriteID) async {
    final db = await instance.database;
    return db.delete('favorites', where: 'id = ?', whereArgs: [favoriteID]);
  }


  Future<int>updateFavoriteRating(int favoriteID, double rating) async{
    final db = await instance.database;
    return await db.update('favorites', {
      'rating': rating
    }, where: 'id = ?', whereArgs: [favoriteID]);
  }
}
