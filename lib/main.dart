import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:games_app/features/games/data/datasources/remote/game_remote_data_source.dart';
import 'package:games_app/features/games/data/datasources/local/database_helper.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:games_app/features/user/presentation/pages/game_page.dart';
import 'package:games_app/features/user/presentation/pages/login_page.dart';
import 'package:games_app/features/user/presentation/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final dio = Dio();
  final dataSource = GameRemoteDataSource(dio: dio);
  final dbHelper = DatabaseHelper.instance;

  runApp(
    RepositoryProvider<GameRemoteDataSource>(
      create: (_) => dataSource,
      child: MyApp(dbHelper: dbHelper),
    ),
  );
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const MyApp({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GameBloc(context.read<GameRemoteDataSource>()),
        ),
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
        BlocProvider(
          create: (_) => FavoriteBloc(dbHelper),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          '/home': (context) => const GamePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
