import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/games/data/datasources/remote/game_remote_data_source.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_event.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_state.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_event.dart';
import 'package:games_app/features/user/presentation/pages/game_detail_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController controller = TextEditingController();
  bool searchExact = false;
  bool isDescending = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<GameBloc>();
    bloc.add(FetchRecentGames());
    bloc.add(GetGenres());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Jogos'),
        actions: [
          TextButton(
            onPressed: () async {},
            child: Text('Login', style: TextStyle(color: Colors.blueAccent)),
          ),
          IconButton(
            icon: Icon(isDescending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                isDescending = !isDescending;
              });

              context.read<GameBloc>().add(
                SortGamesByRatingEvent(descending: isDescending),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Digite o nome de um Jogo',
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<GameBloc>().add(
                      SearchGames(controller.text, searchExact: searchExact),
                    );
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: searchExact,
                onChanged: (value) {
                  setState(() {
                    searchExact = value ?? false;
                  });
                },
              ),
              Text('Filtrar por nome'),
            ],
          ),
          Expanded(
            child: BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state is GameLoading || state is GenreLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is GameLoaded) {
                  return ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.genres.length,
                          itemBuilder: (context, index) {
                            final genre = state.genres[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<GameBloc>().add(
                                    FilterGamesByGenre(genre.id),
                                  );
                                },
                                child: Chip(
                                  label: Text(genre.name),
                                  backgroundColor: Colors.blueGrey,
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(color: Colors.white70),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 16),
                      ...state.games.map(
                        (game) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  final repository = context
                                      .read<GameRemoteDataSource>();
                                  return BlocProvider(
                                    create: (_) => GameDetailBloc(repository)
                                      ..add(FetchGameDetails(gameID: game.id)),
                                    child: const GameDetailPage(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                game.backgroundImage != null
                                    ? Image.network(
                                        game.backgroundImage!,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 180,
                                        color: Colors.grey,
                                        child: Center(
                                          child: Icon(
                                            Icons.videogame_asset,
                                            size: 50,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),

                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        game.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Nota: ${game.rating?.toStringAsFixed(1) ?? 'N/A'}",
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is GameError) {
                  return Center(child: Text(state.message));
                }

                return Center(child: Text('Busque por um game!'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
