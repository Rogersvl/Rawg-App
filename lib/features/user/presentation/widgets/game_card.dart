import 'package:flutter/material.dart';
import 'package:games_app/features/games/data/models/game_model.dart';

class GameCard extends StatelessWidget {
  final GameModel game;

  const GameCard({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          game.backgroundImage != null
              ? Image.network(
                  game.backgroundImage!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[400],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.white70,
                    ),
                  ),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Text(
                "Nota: ${game.rating?.toStringAsFixed(1) ?? 'N/A'} | ${game.released ?? 'Desconhecido'}",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
