import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/games/data/datasources/game_remote_data_source.dart';
import 'package:games_app/features/games/data/local/database_helper.dart';
import 'package:games_app/features/user/presentation/pages/login_page.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:games_app/features/user/presentation/pages/game_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;

  final dio = Dio();
  final dataSource = GameRemoteDataSource(dio: dio);

  runApp(
    RepositoryProvider<GameRemoteDataSource>(
      create: (_) => dataSource,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        "/login": (context) => LoginPage(),
        "/home": (context) => GamePage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GameBloc(context.read<GameRemoteDataSource>()),
          ),
        ],
        child: GamePage(),
      ),

      debugShowCheckedModeBanner: false,
    );
  }
}
