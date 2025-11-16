import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scratch_card/scratch_card.dart';
import '../bloc/games/scratch_card/scratch_card_bloc.dart';
import '../bloc/games/scratch_card/scratch_card_event.dart';
import '../bloc/games/scratch_card/scratch_card_state.dart';

class ScratchCardWidget extends StatefulWidget {
  const ScratchCardWidget({super.key});

  @override
  State<ScratchCardWidget> createState() => _ScratchCardWidgetState();
}

class _ScratchCardWidgetState extends State<ScratchCardWidget> {
  ScratchCardReward? _currentReward;
  bool _isScratched = false;
  int _scratchPercentage = 0;
  ScratchCardReward? _lastShownReward;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScratchCardBloc, ScratchCardState>(
      listener: (context, state) {
        if (state is ScratchCardLoaded &&
            state.lastReward != null &&
            state.isScratched &&
            state.lastReward != _lastShownReward) {
          // Show reward dialog after scratch completes (only once per reward)
          _lastShownReward = state.lastReward;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _showRewardDialog(context, state.lastReward!);
            }
          });
        }
      },
      child: BlocBuilder<ScratchCardBloc, ScratchCardState>(
        builder: (context, state) {
          if (state is ScratchCardLoaded) {
            // Get random reward if not already set
            if (_currentReward == null && state.canScratch && !_isScratched) {
              final bloc = context.read<ScratchCardBloc>();
              _currentReward = bloc.getRandomReward();
            }

            return Column(
              children: [
                // Scratch Card
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ScratchCard(
                      scratchColor: Colors.grey,
                      stockSize: 50,
                      scratchPercentage: (percentage) {
                        setState(() {
                          _scratchPercentage = percentage;
                        });
                        // When user scratches enough (50%), reveal reward
                        if (percentage >= 50 &&
                            _currentReward != null &&
                            !_isScratched) {
                          setState(() {
                            _isScratched = true;
                          });
                          // Trigger scratch complete event
                          context.read<ScratchCardBloc>().add(
                            ScratchCardScratchCompleteEvent(_currentReward!.id),
                          );
                        }
                      },
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.amber[400]!, Colors.orange[400]!],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 64,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              if (_currentReward != null && _isScratched)
                                Text(
                                  _currentReward!.label,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              else
                                Column(
                                  children: [
                                    Text(
                                      'Cào thẻ trúng thưởng',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Vuốt để cào',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Progress indicator
                if (!_isScratched && state.canScratch)
                  Column(
                    children: [
                      Text(
                        'Tiến độ: $_scratchPercentage%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _scratchPercentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ],
                  ),
                // Reward Display (when scratched)
                if (state.isScratched && state.lastReward != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getRewardColor(state.lastReward!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Phần thưởng của bạn:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.lastReward!.label,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (state.canScratch && !_isScratched)
                  Text(
                    'Còn ${state.scratchesRemaining} lượt cào',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  )
                else if (!state.canScratch)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Đã hết lượt cào hôm nay',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
              ],
            );
          } else if (state is ScratchCardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ScratchCardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${state.message}'),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _getRewardColor(ScratchCardReward reward) {
    if (reward.type == 'none') {
      return Colors.grey;
    } else if (reward.type == 'voucher') {
      return Colors.purple;
    }
    return Colors.amber;
  }

  void _showRewardDialog(BuildContext context, ScratchCardReward reward) {
    final isNoReward = reward.type == 'none';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isNoReward ? Icons.sentiment_dissatisfied : Icons.celebration,
              color: isNoReward ? Colors.grey : Colors.amber,
            ),
            const SizedBox(width: 8),
            Text(isNoReward ? 'Chưa may mắn' : 'Chúc mừng!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isNoReward ? 'Kết quả:' : 'Bạn đã nhận được:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isNoReward
                    ? Colors.grey[200]
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                reward.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isNoReward
                      ? Colors.grey[700]
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            if (isNoReward) ...[
              const SizedBox(height: 16),
              Text(
                'Hãy thử lại lần sau nhé!',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(isNoReward ? 'OK' : 'Tuyệt vời!'),
          ),
        ],
      ),
    );
  }
}
