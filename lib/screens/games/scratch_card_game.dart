import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin/coin_bloc.dart';
import '../../bloc/coin/coin_event.dart';
import '../../bloc/coin/coin_state.dart';
import '../../bloc/games/scratch_card/scratch_card_bloc.dart';
import '../../bloc/games/scratch_card/scratch_card_event.dart';
import '../../bloc/games/scratch_card/scratch_card_state.dart';
import '../../widgets/scratch_card_widget.dart';

class ScratchCardGameScreen extends StatefulWidget {
  const ScratchCardGameScreen({super.key});

  @override
  State<ScratchCardGameScreen> createState() => _ScratchCardGameScreenState();
}

class _ScratchCardGameScreenState extends State<ScratchCardGameScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get CoinBloc from parent context (provided in main.dart)
    final coinBloc = context.read<CoinBloc>();

    return BlocProvider(
      create: (context) => ScratchCardBloc(),
      child: BlocListener<ScratchCardBloc, ScratchCardState>(
        listener: (context, state) {
          // When scratch completes and reward is received, add coins
          if (state is ScratchCardLoaded &&
              state.lastReward != null &&
              state.isScratched) {
            final reward = state.lastReward!;
            if (reward.type == 'coin' && reward.coinAmount > 0) {
              coinBloc.add(CoinAddEvent(reward.coinAmount));
            }
            // TODO: Handle voucher rewards when voucher system is implemented
          }
        },
        child: BlocBuilder<ScratchCardBloc, ScratchCardState>(
          builder: (context, state) {
            // Disable swipe back when scratching or scratched
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Cào thẻ trúng thưởng'),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
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
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$coins',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hướng dẫn',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• Vuốt ngón tay trên thẻ để cào\n'
                                '• Mỗi ngày bạn có 1-2 lượt cào miễn phí\n'
                                '• Nhận coin hoặc voucher ngẫu nhiên sau khi cào',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Scratch Card Widget
                        const Center(child: ScratchCardWidget()),
                        const SizedBox(height: 32),
                        // Rewards Info
                        // Reset Button (Demo Only)
                        BlocBuilder<ScratchCardBloc, ScratchCardState>(
                          builder: (context, state) {
                            if (state is ScratchCardLoaded &&
                                !state.canScratch) {
                              return Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      border: Border.all(
                                        color: Colors.orange[200]!,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            context.read<ScratchCardBloc>().add(
                                              const ScratchCardResetEvent(),
                                            );
                                          },
                                          icon: const Icon(Icons.refresh),
                                          label: const Text('Reset lượt cào'),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
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
            );
          },
        ),
      ),
    );
  }

  Color _getColorForReward(ScratchCardReward reward) {
    if (reward.type == 'voucher') {
      return Colors.purple[100]!;
    } else if (reward.type == 'none') {
      return Colors.grey[300]!;
    }
    return Colors.amber[100]!;
  }
}
