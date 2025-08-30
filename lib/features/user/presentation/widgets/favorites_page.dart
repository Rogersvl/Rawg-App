import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_event.dart';
import 'package:games_app/features/user/presentation/bloc/favorite_bloc/favorite_state.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/auth/auth_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    int? userID;

    if (authState is AuthAuthenticated) {
      userID = authState.user.id;
    }

    if (userID == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Favoritos')),
        body: const Center(
          child: Text('Você precisa estar logado para ver seus favoritos.'),
        ),
      );
    }
    context.read<FavoriteBloc>().add(LoadFavorites(userID));

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('Nenhum favorito encontrado.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final fav = state.favorites[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      fav['background_image'] != null
                          ? Image.network(
                              fav['background_image'],
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[400],
                              child: const Center(
                                child: Icon(
                                  Icons.videogame_asset,
                                  size: 50,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  fav['name'] ?? 'Desconhecido',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  context.read<FavoriteBloc>().add(
                                        RemoveFavorite(
                                          favoriteID: fav['id'],
                                          userID: userID!,
                                        ),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Carregando favoritos...'));
        },
      ),
    );
  }
}
