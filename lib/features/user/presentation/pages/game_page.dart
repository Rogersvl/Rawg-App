import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/games/data/datasources/remote/game_remote_data_source.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_event.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_state.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_event.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_state.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_event.dart';
import 'package:games_app/features/user/presentation/bloc/game_bloc/game_state.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_event.dart';
import 'package:games_app/features/user/presentation/pages/game_detail_page.dart';
import 'package:games_app/features/user/presentation/widgets/favorites_page.dart';
import 'package:games_app/features/user/presentation/widgets/game_card.dart';

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

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final favoriteBloc = context.read<FavoriteBloc>();
      favoriteBloc.add(LoadFavorites(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Jogos'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Olá, ${state.user.name}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<FavoriteBloc>(),
                              child: const FavoritesPage(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Meus Favoritos',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    ),
                  ],
                );
              } else {
                return TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
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
                  icon: const Icon(Icons.search),
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
              const Text('Busca filtrada'),
              Checkbox(
                value: isDescending,
                onChanged: (value) {
                  setState(() {
                    isDescending = !isDescending;
                  });
                  context.read<GameBloc>().add(
                    SortGamesByRatingEvent(descending: isDescending),
                  );
                },
              ),
              Text(isDescending ? 'Decrescente' : 'Crescente'),
            ],
          ),
          Expanded(
            child: BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state is GameLoading || state is GenreLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GameLoaded) {
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      int? userId;
                      if (authState is AuthAuthenticated) {
                        userId = authState.user.id;
                        context.read<FavoriteBloc>().add(LoadFavorites(userId));
                      }

                      return BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, favState) {
                          List<int> favoriteIds = [];
                          if (favState is FavoriteLoaded) {
                            favoriteIds = favState.favorites
                                .map((f) => f['game_id'] as int)
                                .toList();
                          }

                          return ListView(
                            padding: const EdgeInsets.all(12),
                            children: [
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.genres.length,
                                  itemBuilder: (context, index) {
                                    final genre = state.genres[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
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
                                          shape: const StadiumBorder(
                                            side: BorderSide(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...state.games.map((game) {
                                final isFavorite = favoriteIds.contains(
                                  game.id,
                                );
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              final repository = context
                                                  .read<GameRemoteDataSource>();
                                              return BlocProvider(
                                                create: (_) =>
                                                    GameDetailBloc(repository)
                                                      ..add(
                                                        FetchGameDetails(
                                                          gameID: game.id,
                                                        ),
                                                      ),
                                                child: const GameDetailPage(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: GameCard(game: game),
                                    ),
                                    if (userId != null)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.redAccent,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            if (isFavorite) {
                                              final favorite =
                                                  (favState as FavoriteLoaded)
                                                      .favorites
                                                      .firstWhere(
                                                        (f) =>
                                                            f['game_id'] ==
                                                            game.id,
                                                      );
                                              context.read<FavoriteBloc>().add(
                                                RemoveFavorite(
                                                  favoriteID: favorite['id'],
                                                  userID: userId!,
                                                ),
                                              );
                                            } else {
                                              context.read<FavoriteBloc>().add(
                                                AddFavorite(
                                                  userID: userId!,
                                                  gameID: game.id,
                                                  name: game.name,
                                                  backgroundImage:
                                                      game.backgroundImage ??
                                                      '',
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                );
                              }),
                            ],
                          );
                        },
                      );
                    },
                  );
                }

                if (state is GameError) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: Text('Busque por um game!'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
