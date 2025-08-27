import 'package:dio/dio.dart';
import 'package:games_app/features/user/data/models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource({required this.dio});

  Future<UserModel> login(String email, String password) async {
    final response = await dio.post(
      'https://suaapi.com/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Falha no login');
    }
  }
}