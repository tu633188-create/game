import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin/coin_bloc.dart';
import '../../bloc/coin/coin_event.dart';
import '../../bloc/coin/coin_state.dart';
import '../../bloc/games/lucky_wheel/lucky_wheel_bloc.dart';
import '../../bloc/games/lucky_wheel/lucky_wheel_event.dart';
import '../../bloc/games/lucky_wheel/lucky_wheel_state.dart';
import '../../widgets/lucky_wheel_widget.dart';

class LuckyWheelGameScreen extends StatelessWidget {
  const LuckyWheelGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get CoinBloc from parent context (provided in main.dart)
    final coinBloc = context.read<CoinBloc>();

    return BlocProvider(
      create: (context) => LuckyWheelBloc(),
      child: BlocListener<LuckyWheelBloc, LuckyWheelState>(
        listener: (context, state) {
          // When spin completes and reward is received, add coins
          if (state is LuckyWheelLoaded && state.lastReward != null) {
            final reward = state.lastReward!;
            if (reward.type == 'coin' && reward.coinAmount > 0) {
              coinBloc.add(CoinAddEvent(reward.coinAmount));
            }
            // TODO: Handle voucher rewards when voucher system is implemented
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Vòng quay may mắn'),
            actions: [
              // Coin Display
              BlocBuilder<CoinBloc, CoinState>(
                bloc: coinBloc,
                builder: (context, coinState) {
                  int coins = 0;
                  if (coinState is CoinLoaded) {
                    coins = coinState.totalCoins;
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
              // Demo Badge
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DEMO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Hướng dẫn',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Nhấn nút "Quay ngay" để bắt đầu quay vòng quay may mắn\n'
                          '• Mỗi ngày bạn có 3-5 lượt quay miễn phí\n'
                          '• Nhận coin hoặc voucher ngẫu nhiên sau mỗi lượt quay',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Lucky Wheel Widget
                  const Center(
                    child: LuckyWheelWidget(),
                  ),
                  const SizedBox(height: 32),
                  // Rewards Info
                  BlocBuilder<LuckyWheelBloc, LuckyWheelState>(
                    builder: (context, state) {
                      if (state is LuckyWheelLoaded) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phần thưởng có thể nhận:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: state.rewards.map((reward) {
                                      return Chip(
                                        label: Text(reward.label),
                                        backgroundColor: _getColorForReward(reward),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            // Reset Button (Demo Only)
                            if (!state.canSpin) ...[
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  border: Border.all(color: Colors.orange[200]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.bug_report,
                                          size: 16,
                                          color: Colors.orange[700],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'DEMO ONLY',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        context.read<LuckyWheelBloc>().add(
                                              const LuckyWheelResetEvent(),
                                            );
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Reset lượt quay'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Nút này chỉ để demo, không có trong app thực tế',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForReward(LuckyWheelReward reward) {
    if (reward.type == 'voucher') {
      return Colors.purple[100]!;
    }
    return Colors.amber[100]!;
  }
}

