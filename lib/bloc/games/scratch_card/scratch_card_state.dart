import 'package:equatable/equatable.dart';

class ScratchCardReward {
  final String id;
  final String label;
  final int coinAmount;
  final String? voucherId;
  final String type; // 'coin' or 'voucher' or 'none'

  const ScratchCardReward({
    required this.id,
    required this.label,
    required this.coinAmount,
    this.voucherId,
    required this.type,
  });
}

abstract class ScratchCardState extends Equatable {
  const ScratchCardState();

  @override
  List<Object> get props => [];
}

class ScratchCardInitial extends ScratchCardState {
  const ScratchCardInitial();
}

class ScratchCardLoading extends ScratchCardState {
  const ScratchCardLoading();
}

class ScratchCardLoaded extends ScratchCardState {
  final List<ScratchCardReward> availableRewards;
  final int scratchesRemaining;
  final bool canScratch;
  final ScratchCardReward? lastReward;
  final bool isScratched;

  const ScratchCardLoaded({
    required this.availableRewards,
    required this.scratchesRemaining,
    this.canScratch = true,
    this.lastReward,
    this.isScratched = false,
  });

  ScratchCardLoaded copyWith({
    List<ScratchCardReward>? availableRewards,
    int? scratchesRemaining,
    bool? canScratch,
    ScratchCardReward? lastReward,
    bool? isScratched,
  }) {
    return ScratchCardLoaded(
      availableRewards: availableRewards ?? this.availableRewards,
      scratchesRemaining: scratchesRemaining ?? this.scratchesRemaining,
      canScratch: canScratch ?? this.canScratch,
      lastReward: lastReward ?? this.lastReward,
      isScratched: isScratched ?? this.isScratched,
    );
  }

  @override
  List<Object> get props => [
    availableRewards,
    scratchesRemaining,
    canScratch,
    isScratched,
  ];
}

class ScratchCardScratching extends ScratchCardState {
  final List<ScratchCardReward> availableRewards;
  final int scratchesRemaining;

  const ScratchCardScratching({
    required this.availableRewards,
    required this.scratchesRemaining,
  });

  @override
  List<Object> get props => [availableRewards, scratchesRemaining];
}

class ScratchCardError extends ScratchCardState {
  final String message;

  const ScratchCardError(this.message);

  @override
  List<Object> get props => [message];
}
