import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin/coin_bloc.dart';
import '../bloc/coin/coin_state.dart';
import '../services/game_info_service.dart';
import '../widgets/game_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = GameInfoService.getAllGames();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Games Demo'),
        actions: [
          BlocBuilder<CoinBloc, CoinState>(
            builder: (context, state) {
              int coins = 0;
              if (state is CoinLoaded) {
                coins = state.totalCoins;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '$coins',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Introduction Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Các game demo để tăng lưu lượng truy cập app TMDT',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chơi game để tích xu và nhận voucher. Mỗi game có thể tích hợp vào các vị trí khác nhau trong app.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Games List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: games.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GameCardWidget(game: games[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

