import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_bloc.dart';
import 'package:games_app/features/user/presentation/bloc/game_detail_bloc/game_detail_state.dart';

class GameDetailPage extends StatelessWidget {
  const GameDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GameDetailBloc, GameDetailState>(
        builder: (context, state) {
          if (state is GameDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GameDetailLoaded) {
            final game = state.gameDetail;
            final screenshots = state.gameScreenShots;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(game.name ?? 'Sem nome'),
                    background: Image.network(
                      game.backgroundImage ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating
                        Text(
                          'Nota: ${game.rating?.toStringAsFixed(1) ?? "N/A"}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          game.description ?? 'Sem descrição disponível',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),

                        // Screenshots
                        if (screenshots.isNotEmpty) ...[
                          const Text(
                            "Screenshots:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: screenshots.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    screenshots[index],
                                    width: 300,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Carregando detalhes...'));
        },
      ),
    );
  }
}
