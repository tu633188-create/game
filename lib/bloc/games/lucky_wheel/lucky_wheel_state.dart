import 'package:equatable/equatable.dart';

class LuckyWheelReward {
  final String label;
  final int coinAmount;
  final String? voucherId;
  final String type; // 'coin' or 'voucher'

  const LuckyWheelReward({
    required this.label,
    required this.coinAmount,
    this.voucherId,
    required this.type,
  });
}

abstract class LuckyWheelState extends Equatable {
  const LuckyWheelState();

  @override
  List<Object> get props => [];
}

class LuckyWheelInitial extends LuckyWheelState {
  const LuckyWheelInitial();
}

class LuckyWheelLoading extends LuckyWheelState {
  const LuckyWheelLoading();
}

class LuckyWheelLoaded extends LuckyWheelState {
  final List<LuckyWheelReward> rewards;
  final int spinsRemaining;
  final bool canSpin;
  final LuckyWheelReward? lastReward;

  const LuckyWheelLoaded({
    required this.rewards,
    required this.spinsRemaining,
    this.canSpin = true,
    this.lastReward,
  });

  LuckyWheelLoaded copyWith({
    List<LuckyWheelReward>? rewards,
    int? spinsRemaining,
    bool? canSpin,
    LuckyWheelReward? lastReward,
  }) {
    return LuckyWheelLoaded(
      rewards: rewards ?? this.rewards,
      spinsRemaining: spinsRemaining ?? this.spinsRemaining,
      canSpin: canSpin ?? this.canSpin,
      lastReward: lastReward ?? this.lastReward,
    );
  }

  @override
  List<Object> get props => [rewards, spinsRemaining, canSpin];
}

class LuckyWheelSpinning extends LuckyWheelState {
  final List<LuckyWheelReward> rewards;
  final int spinsRemaining;

  const LuckyWheelSpinning({
    required this.rewards,
    required this.spinsRemaining,
  });

  @override
  List<Object> get props => [rewards, spinsRemaining];
}

class LuckyWheelError extends LuckyWheelState {
  final String message;

  const LuckyWheelError(this.message);

  @override
  List<Object> get props => [message];
}

