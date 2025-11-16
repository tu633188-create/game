import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin/coin_bloc.dart';
import '../../bloc/coin/coin_event.dart';
import '../../games/whack_a_mole/main.dart' as whack_a_mole;

class WhackMoleGameScreen extends StatefulWidget {
  const WhackMoleGameScreen({super.key});

  @override
  State<WhackMoleGameScreen> createState() => _WhackMoleGameScreenState();
}

class _WhackMoleGameScreenState extends State<WhackMoleGameScreen> {
  int _gameCoins = 0; // Coin kiếm được trong game hiện tại

  @override
  Widget build(BuildContext context) {
    final coinBloc = context.read<CoinBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đập chuột'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '$_gameCoins',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: whack_a_mole.LevelView(
        onCoinEarned: (coins) {
          // Cập nhật coin trong game
          setState(() {
            _gameCoins += coins;
          });
          // Thêm coin vào CoinBloc
          coinBloc.add(CoinAddEvent(coins));
        },
        onCoinSubtracted: (coins) {
          // Cập nhật coin trong game
          setState(() {
            _gameCoins -= coins;
          });
          // Trừ coin khi đập trúng bomber
          coinBloc.add(CoinSubtractEvent(coins));
        },
        onGameStart: () {
          // Reset coin khi game bắt đầu
          setState(() {
            _gameCoins = 0;
          });
        },
      ),
    );
  }
}
