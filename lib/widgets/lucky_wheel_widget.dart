import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import '../bloc/games/lucky_wheel/lucky_wheel_bloc.dart';
import '../bloc/games/lucky_wheel/lucky_wheel_event.dart';
import '../bloc/games/lucky_wheel/lucky_wheel_state.dart';

class LuckyWheelWidget extends StatefulWidget {
  const LuckyWheelWidget({super.key});

  @override
  State<LuckyWheelWidget> createState() => _LuckyWheelWidgetState();
}

class _LuckyWheelWidgetState extends State<LuckyWheelWidget> {
  final StreamController<int> _selectedController =
      StreamController<int>.broadcast();
  final Random _random = Random();
  StreamSubscription<int>? _spinSubscription;
  LuckyWheelReward? _lastShownReward;

  @override
  void initState() {
    super.initState();
    // Listen to spin completion
    _spinSubscription = _selectedController.stream.listen((selectedIndex) {
      // Wait for animation to complete (3 seconds)
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          context.read<LuckyWheelBloc>().add(
            LuckyWheelSpinCompleteEvent(selectedIndex),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _spinSubscription?.cancel();
    _selectedController.close();
    super.dispose();
  }

  void _onSpin() {
    final bloc = context.read<LuckyWheelBloc>();
    final state = bloc.state;

    if (state is LuckyWheelLoaded && !state.canSpin) {
      return;
    }

    // Trigger spin event
    bloc.add(const LuckyWheelSpinEvent());

    // Select random index after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && state is LuckyWheelLoaded) {
        final selectedIndex = _random.nextInt(state.rewards.length);
        _selectedController.add(selectedIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LuckyWheelBloc, LuckyWheelState>(
      listener: (context, state) {
        if (state is LuckyWheelLoaded &&
            state.lastReward != null &&
            state.lastReward != _lastShownReward) {
          // Show reward dialog after spin completes (only once per reward)
          _lastShownReward = state.lastReward;
          _showRewardDialog(context, state.lastReward!);
        }
      },
      child: BlocBuilder<LuckyWheelBloc, LuckyWheelState>(
        builder: (context, state) {
          if (state is LuckyWheelLoaded) {
            return Column(
              children: [
                // Wheel
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FortuneWheel(
                        selected: _selectedController.stream,
                        animateFirst: false,
                        physics: CircularPanPhysics(
                          duration: const Duration(seconds: 3),
                          curve: Curves.decelerate,
                        ),
                        onFling: () {
                          // This is called when user drags the wheel
                          // We'll use button instead, but keep this for manual spinning
                        },
                        indicators: <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: Colors.amber,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                        items: [
                          for (var i = 0; i < state.rewards.length; i++)
                            FortuneItem(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.rewards[i].label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              style: FortuneItemStyle(
                                color: _getColorForReward(state.rewards[i], i),
                                borderColor: Colors.white,
                                borderWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Spin Button
                ElevatedButton.icon(
                  onPressed: state.canSpin ? _onSpin : null,
                  icon: const Icon(Icons.casino),
                  label: Text(
                    state.canSpin
                        ? 'Quay ngay (${state.spinsRemaining} lượt còn lại)'
                        : 'Đã hết lượt quay hôm nay',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          } else if (state is LuckyWheelSpinning) {
            return Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FortuneWheel(
                        selected: _selectedController.stream,
                        animateFirst: false,
                        physics: CircularPanPhysics(
                          duration: const Duration(seconds: 3),
                          curve: Curves.decelerate,
                        ),
                        indicators: <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: Colors.amber,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                        items: [
                          for (var i = 0; i < state.rewards.length; i++)
                            FortuneItem(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.rewards[i].label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              style: FortuneItemStyle(
                                color: _getColorForReward(state.rewards[i], i),
                                borderColor: Colors.white,
                                borderWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Đang quay...'),
              ],
            );
          } else if (state is LuckyWheelLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LuckyWheelError) {
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

  Color _getColorForReward(LuckyWheelReward reward, int index) {
    // Màu xám cho "Chúc bạn may mắn lần sau"
    if (reward.type == 'none') {
      return Colors.grey;
    }

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
    return colors[index % colors.length];
  }

  void _showRewardDialog(BuildContext context, LuckyWheelReward reward) {
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
