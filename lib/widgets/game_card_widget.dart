import 'package:flutter/material.dart';
import '../models/game_info_model.dart';
import 'game_info_dialog.dart';
import '../screens/games/placeholder_game_screen.dart';
import '../screens/games/lucky_wheel_game.dart';
import '../screens/games/scratch_card_game.dart';

class GameCardWidget extends StatelessWidget {
  final GameInfo game;

  const GameCardWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    game.icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                // Info Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => GameInfoDialog(game: game),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Info'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Play Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Widget gameScreen;
                      switch (game.id) {
                        case 'lucky_wheel':
                          gameScreen = const LuckyWheelGameScreen();
                          break;
                        case 'scratch_card':
                          gameScreen = const ScratchCardGameScreen();
                          break;
                        default:
                          gameScreen = PlaceholderGameScreen(game: game);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => gameScreen),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Demo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
