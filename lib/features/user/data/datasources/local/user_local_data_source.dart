// import 'package:games_app/features/user/data/models/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class UserLocalDataSource {
//   Future<void> saveUser(UserModel user) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('user', jsonEncode(user.toJson()));
//   }

//   Future<UserModel?> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userJson = prefs.getString('user');
//     if (userJson == null) return null;
//     return UserModel.fromJson(jsonDecode(userJson));
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove('user');
//   }
// }
