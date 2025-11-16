import 'package:flutter/material.dart';
import '../memory_game_screen.dart' show MemoryCardData;

class MemoryCardWidget extends StatelessWidget {
  final MemoryCardData card;
  final VoidCallback onTap;

  const MemoryCardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.green[100]
              : card.isFlipped
              ? Colors.white
              : Colors.blue[400],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: card.isMatched
                ? Colors.green
                : card.isFlipped
                ? Colors.blue
                : Colors.blue[700]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (card.isMatched) {
      // Hiển thị checkmark khi đã match
      return const Center(
        child: Icon(Icons.check_circle, color: Colors.green, size: 40),
      );
    }

    if (card.isFlipped) {
      // Hiển thị số/icon khi lật
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForValue(card.value),
              size: 40,
              color: _getColorForValue(card.value),
            ),
            const SizedBox(height: 4),
            Text(
              '${card.value}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getColorForValue(card.value),
              ),
            ),
          ],
        ),
      );
    }

    // Hiển thị dấu hỏi khi chưa lật
    return const Center(
      child: Icon(Icons.help_outline, size: 40, color: Colors.white),
    );
  }

  IconData _getIconForValue(int value) {
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.thumb_up,
      Icons.celebration,
      Icons.local_fire_department,
      Icons.emoji_events,
      Icons.diamond,
      Icons.bolt,
    ];
    return icons[(value - 1) % icons.length];
  }

  Color _getColorForValue(int value) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];
    return colors[(value - 1) % colors.length];
  }
}
