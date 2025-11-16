import 'package:flutter/material.dart';
import '../models/game_info_model.dart';

class GameInfoDialog extends StatelessWidget {
  final GameInfo game;

  const GameInfoDialog({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    child: Text(
                      game.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                game.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Vị trí tích hợp
              _buildSection(
                context,
                '📍 Vị trí tích hợp:',
                game.integrationLocations,
                Icons.location_on,
              ),
              const SizedBox(height: 16),

              // Tác dụng
              _buildSection(
                context,
                '🎯 Tác dụng:',
                game.benefits,
                Icons.trending_up,
              ),
              const SizedBox(height: 16),

              // Cơ chế reward
              _buildRewardSection(context),
              const SizedBox(height: 16),

              // Best Practice
              _buildSection(
                context,
                '💡 Best Practice:',
                game.bestPractices,
                Icons.lightbulb,
              ),
              const SizedBox(height: 16),

              // Admin Management
              _buildSection(
                context,
                '⚙️ Quản lý Admin:',
                game.adminManagement,
                Icons.admin_panel_settings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> items,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildRewardSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.monetization_on,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '💰 Cơ chế reward:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            game.rewardMechanism,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

