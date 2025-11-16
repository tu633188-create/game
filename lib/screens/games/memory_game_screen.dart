import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin/coin_bloc.dart';
import '../../bloc/coin/coin_event.dart';
import 'widgets/memory_card_widget.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<MemoryCardData> _cards;
  MemoryCardData? _firstCard;
  MemoryCardData? _secondCard;
  bool _isProcessing = false;
  int _moves = 0;
  int _pairsFound = 0;
  int _totalPairs = 0;
  bool _gameWon = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Tạo 8 cặp (16 thẻ) cho level 1
    _totalPairs = 8;
    final List<int> cardValues = List.generate(_totalPairs, (i) => i + 1);
    final List<int> allCards = [
      ...cardValues,
      ...cardValues,
    ]; // Duplicate để có cặp

    // Shuffle
    allCards.shuffle(Random());

    _cards = allCards.asMap().entries.map((entry) {
      return MemoryCardData(
        id: entry.key,
        value: entry.value,
        isFlipped: false,
        isMatched: false,
      );
    }).toList();

    _moves = 0;
    _pairsFound = 0;
    _gameWon = false;
  }

  void _onCardTap(MemoryCardData card) {
    if (_isProcessing || card.isFlipped || card.isMatched || _gameWon) {
      return;
    }

    setState(() {
      if (_firstCard == null) {
        // Lật thẻ đầu tiên
        _firstCard = card;
        card.isFlipped = true;
      } else if (_secondCard == null && card != _firstCard) {
        // Lật thẻ thứ hai
        _secondCard = card;
        card.isFlipped = true;
        _moves++;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    if (_firstCard == null || _secondCard == null) return;

    _isProcessing = true;

    if (_firstCard!.value == _secondCard!.value) {
      // Match found!
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _firstCard!.isMatched = true;
            _secondCard!.isMatched = true;
            _pairsFound++;
            _firstCard = null;
            _secondCard = null;
            _isProcessing = false;

            // Check if game is won
            if (_pairsFound == _totalPairs) {
              _gameWon = true;
              _showWinDialog();
            }
          });
        }
      });
    } else {
      // No match, flip back
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _firstCard!.isFlipped = false;
            _secondCard!.isFlipped = false;
            _firstCard = null;
            _secondCard = null;
            _isProcessing = false;
          });
        }
      });
    }
  }

  void _showWinDialog() {
    // Tính coin dựa trên level (20-50 coin)
    // Level 1 = 20 coin, mỗi level tăng thêm 5 coin
    final int level = 1; // Có thể thay đổi sau
    final int coinsEarned = 20 + (level - 1) * 5;

    // Thêm coin vào CoinBloc
    context.read<CoinBloc>().add(CoinAddEvent(coinsEarned));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text('Chúc mừng!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bạn đã hoàn thành level $level!'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '+$coinsEarned coins',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Số lượt: $_moves'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Chơi lại'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghép hình'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.refresh, size: 20),
                const SizedBox(width: 4),
                Text('$_moves'),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cặp đã tìm: $_pairsFound / $_totalPairs'),
                      if (_gameWon)
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'Hoàn thành!',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _pairsFound / _totalPairs,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Game grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return MemoryCardWidget(
                      card: _cards[index],
                      onTap: () => _onCardTap(_cards[index]),
                    );
                  },
                ),
              ),
            ),
            // Reset button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Chơi lại'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoryCardData {
  final int id;
  final int value;
  bool isFlipped;
  bool isMatched;

  MemoryCardData({
    required this.id,
    required this.value,
    required this.isFlipped,
    required this.isMatched,
  });
}
