
import 'package:games_app/features/games/data/datasources/local/database_helper.dart';
import 'package:games_app/features/user/domain/entities/user.dart';

class UserRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<User?> login(String email, String password) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<User> register(String name, String email, String password, {String? profileImagePath}) async {
    final db = await dbHelper.database;
    final id = await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
      'profile_image_path': profileImagePath,
    });
    return User(id: id, name: name, email: email, password: password, profileImagePath: profileImagePath);
  }
}

